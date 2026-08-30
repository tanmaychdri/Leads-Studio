import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/core/sync/sync_models.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/drive/data/services/google_drive_service.dart';
import 'package:leads_studio/features/excel/data/services/excel_service.dart';
import 'package:leads_studio/features/excel/data/models/lead.dart' as excel_models;
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/drive/presentation/providers/drive_provider.dart';
import 'package:drift/drift.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:leads_studio/features/database/presentation/providers/database_provider.dart';
import 'package:leads_studio/features/excel/presentation/providers/excel_provider.dart';

final syncStateProvider = StateProvider<SyncState>((ref) => const SyncState());

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(
    ref: ref,
    db: ref.watch(appDatabaseProvider),
    driveService: ref.watch(googleDriveServiceProvider),
    excelService: ref.watch(excelServiceProvider),
  );
});

class SyncEngine {
  final Ref ref;
  final AppDatabase db;
  final GoogleDriveService driveService;
  final ExcelService excelService;

  SyncEngine({
    required this.ref,
    required this.db,
    required this.driveService,
    required this.excelService,
  });

  Future<void> triggerSync() async {
    final state = ref.read(syncStateProvider);
    if (state.status == SyncStatus.syncing) return;
    
    ref.read(syncStateProvider.notifier).state = state.copyWith(
      status: SyncStatus.syncing,
      errorMessage: null,
    );

    try {
      final metadata = await db.select(db.spreadsheetMetadata).getSingleOrNull();
      if (metadata == null) {
        throw Exception('No active spreadsheet connected.');
      }

      final fileId = metadata.fileId;
      final remoteFileMeta = await driveService.getFileMetadata(fileId);
      final targetMimeType = remoteFileMeta?.mimeType;

      // Always fetch pending local changes
      final pendingChanges = await (db.select(db.leads)..where((tbl) => tbl.syncStatus.isNotValue('synced'))).get();
      final localPendingMap = {for (var lead in pendingChanges) lead.id: lead};
      
      // Always download the file for a full two-way diff
      final tempDir = await getTemporaryDirectory();
      final localSavePath = '${tempDir.path}/sync_temp_workbook.xlsx';
      
      await driveService.downloadFile(fileId, localSavePath);
      await excelService.loadWorkbook(localSavePath);
      
      List<SyncConflict> conflicts = [];
      
      final parseResult = await excelService.parseWorksheet(metadata.worksheetName);
      if (parseResult.error != null) {
        throw Exception('Failed to parse remote worksheet: ${parseResult.error}');
      }

      final remoteLeadsMap = {for (var lead in parseResult.leads) lead.id: lead};
      
      // Get all local leads that are synced (not pending) for deletion checking
      final allLocalLeads = await db.select(db.leads).get();

      // Phase 1: Pull & Conflict Detection
      for (var remoteLead in parseResult.leads) {
        var localLead = await (db.select(db.leads)..where((tbl) => tbl.id.equals(remoteLead.id))).getSingleOrNull();
        
        bool isIdSeedingRequired = false;
        if (localLead == null && (remoteLead.clientName != null || remoteLead.phoneNumber != null)) {
          // Fallback match by name/phone for the initial sync where Excel lacks IDs
          localLead = await (db.select(db.leads)
            ..where((tbl) {
              Expression<bool> nameCond = remoteLead.clientName == null ? tbl.clientName.isNull() : tbl.clientName.equals(remoteLead.clientName!);
              Expression<bool> phoneCond = remoteLead.phoneNumber == null ? tbl.phoneNumber.isNull() : tbl.phoneNumber.equals(remoteLead.phoneNumber!);
              return nameCond & phoneCond;
            }))
            .getSingleOrNull();
          
          if (localLead != null) {
             isIdSeedingRequired = true; // We matched, but remote didn't have the real ID. We must push the real ID back to Excel.
          }
        }

        if (localLead != null) {
          final safeLocalLead = localLead;
          final isPending = localPendingMap.containsKey(safeLocalLead.id);
          final hasResolvedConflictLocally = state.resolvedLocalWins.contains(safeLocalLead.id);

          // Deep diff
          final isSame = _isEqual(safeLocalLead, remoteLead);

          if (!isSame) {
            if (isPending && !hasResolvedConflictLocally) {
              // We have local changes AND remote has different data -> CONFLICT
              conflicts.add(SyncConflict(
                leadId: safeLocalLead.id,
                clientName: safeLocalLead.clientName ?? 'Unknown',
                localData: safeLocalLead.toJson(),
                remoteData: {'status': remoteLead.status, 'notes': remoteLead.notes}, // Simplified representation
              ));
            } else if (!isPending) {
              // No local changes, but remote is different -> PULL updates
              await (db.update(db.leads)..where((tbl) => tbl.id.equals(safeLocalLead.id))).write(LeadsCompanion(
                 clientName: Value(remoteLead.clientName),
                 phoneNumber: Value(remoteLead.phoneNumber),
                 email: Value(remoteLead.email),
                 eventType: Value(remoteLead.eventType),
                 eventDate: Value(remoteLead.eventDate),
                 leadSource: Value(remoteLead.leadSource),
                 status: Value(remoteLead.status),
                 lastContactDate: Value(remoteLead.lastContactDate),
                 nextFollowUpDate: Value(remoteLead.nextFollowUpDate),
                 reminderDate: Value(remoteLead.reminderDate),
                 notes: Value(remoteLead.notes),
                 budget: Value(remoteLead.budget),
                 assignedPerson: Value(remoteLead.assignedPerson),
                 customFields: Value(remoteLead.customFields ?? <String, dynamic>{}),
               ));
            }
          }
          
          if (isIdSeedingRequired) {
            // The excel row didn't have an ID, we must push it back so it gets one.
            // We add it to pendingChanges manually by updating syncStatus
            await (db.update(db.leads)..where((tbl) => tbl.id.equals(safeLocalLead.id))).write(const LeadsCompanion(syncStatus: Value('updated')));
            // Also add it to our in-memory list for Phase 2
            final updatedLocalLead = await (db.select(db.leads)..where((tbl) => tbl.id.equals(safeLocalLead.id))).getSingle();
            pendingChanges.add(updatedLocalLead);
          }
        } else {
          // New remote lead
          await db.into(db.leads).insert(LeadsCompanion.insert(
            id: remoteLead.id,
            userId: metadata.userId,
            clientName: Value(remoteLead.clientName),
            phoneNumber: Value(remoteLead.phoneNumber),
            email: Value(remoteLead.email),
            eventType: Value(remoteLead.eventType),
            eventDate: Value(remoteLead.eventDate),
            leadSource: Value(remoteLead.leadSource),
            status: Value(remoteLead.status),
            lastContactDate: Value(remoteLead.lastContactDate),
            nextFollowUpDate: Value(remoteLead.nextFollowUpDate),
            reminderDate: Value(remoteLead.reminderDate),
            notes: Value(remoteLead.notes),
            budget: Value(remoteLead.budget),
            assignedPerson: Value(remoteLead.assignedPerson),
            customFields: remoteLead.customFields ?? <String, dynamic>{},
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            // Set to updated so we force a push back to Excel to seed the generated UUID!
            syncStatus: const Value('updated'),
          ));
          
          final insertedLead = await (db.select(db.leads)..where((tbl) => tbl.id.equals(remoteLead.id))).getSingle();
          pendingChanges.add(insertedLead);
        }
      }

      // Phase 1.5: Remote Deletions
      for (var localLead in allLocalLeads) {
        if (!remoteLeadsMap.containsKey(localLead.id)) {
          // It's missing in remote!
          if (!localPendingMap.containsKey(localLead.id)) {
             // It was synced before, but now missing remotely. This means it was deleted in Excel.
             await (db.delete(db.leads)..where((tbl) => tbl.id.equals(localLead.id))).go();
          }
        }
      }

      if (conflicts.isNotEmpty) {
        ref.read(syncStateProvider.notifier).state = state.copyWith(
          status: SyncStatus.conflict,
          activeConflicts: conflicts,
        );
        return; // Halt sync until conflicts resolved
      }

      // Phase 2: Push
      bool excelWasModified = false;
      for (var localLead in pendingChanges) {
        if (localLead.syncStatus == 'created' || localLead.syncStatus == 'updated') {
           final excelLead = await _dbLeadToExcelLead(localLead);
           final updatedCustomFields = await excelService.addOrUpdateLead(metadata.worksheetName, excelLead);
           excelWasModified = true;
           if (updatedCustomFields != null) {
              await (db.update(db.leads)..where((tbl) => tbl.id.equals(localLead.id))).write(LeadsCompanion(
                 customFields: Value(updatedCustomFields),
              ));
           }
        } else if (localLead.syncStatus == 'deleted' || localLead.isDeleted) {
           await excelService.removeLead(metadata.worksheetName, localLead.id);
           excelWasModified = true;
        }
      }

      if (excelWasModified) {
        await excelService.saveWorkbook();
        await driveService.updateExcelFile(fileId, localSavePath, targetMimeType: targetMimeType);
      }
      
      // Update all pending to synced regardless of whether excel was modified (since they are now synced)
      if (pendingChanges.isNotEmpty) {
        for (var localLead in pendingChanges) {
          if (localLead.isDeleted) {
             await (db.delete(db.leads)..where((tbl) => tbl.id.equals(localLead.id))).go();
          } else {
             await (db.update(db.leads)..where((tbl) => tbl.id.equals(localLead.id))).write(const LeadsCompanion(syncStatus: Value('synced')));
          }
        }
      }

      // Fetch the updated remote modified time AFTER the push to ensure we have the exact server timestamp!
      final updatedFileMeta = await driveService.getFileMetadata(fileId);
      final finalRemoteTime = updatedFileMeta?.modifiedTime ?? DateTime.now();

      // Update metadata
      await db.update(db.spreadsheetMetadata).replace(metadata.copyWith(
        lastKnownRemoteModifiedTime: Value(finalRemoteTime),
        lastSuccessfulSyncAt: Value(DateTime.now()),
      ));

      ref.read(syncStateProvider.notifier).state = state.copyWith(
        status: SyncStatus.success,
        lastSyncTime: DateTime.now(),
        pendingChangesCount: 0,
        activeConflicts: null,
        resolvedLocalWins: {}, // Clear after successful push
      );
      
    } catch (e) {
      ref.read(syncStateProvider.notifier).state = state.copyWith(
        status: SyncStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> resolveConflict(String leadId, bool keepLocal) async {
    final state = ref.read(syncStateProvider);
    final conflictList = List<SyncConflict>.from(state.activeConflicts ?? []);
    conflictList.removeWhere((c) => c.leadId == leadId);
    
    var newState = state.copyWith(activeConflicts: conflictList);

    if (keepLocal) {
      final newWins = Set<String>.from(state.resolvedLocalWins)..add(leadId);
      newState = newState.copyWith(resolvedLocalWins: newWins);
    } else {
      // Overwrite local with remote
      final conflict = state.activeConflicts?.firstWhere((c) => c.leadId == leadId);
      if (conflict != null) {
        // Find remote lead data from the last pull attempt
        // We set syncStatus to synced so that triggerSync naturally pulls the remote version.
        await (db.update(db.leads)..where((tbl) => tbl.id.equals(leadId))).write(const LeadsCompanion(syncStatus: Value('synced')));
      }
    }

    ref.read(syncStateProvider.notifier).state = newState;
    
    // Automatically trigger sync again to continue
    triggerSync();
  }

  bool _isEqual(Lead local, excel_models.Lead remote) {
    if (local.clientName != remote.clientName) return false;
    if (local.phoneNumber != remote.phoneNumber) return false;
    if (local.email != remote.email) return false;
    if (local.eventType != remote.eventType) return false;
    if (local.eventDate != remote.eventDate) return false;
    if (local.leadSource != remote.leadSource) return false;
    if (local.status != remote.status) return false;
    if (local.lastContactDate != remote.lastContactDate) return false;
    if (local.nextFollowUpDate != remote.nextFollowUpDate) return false;
    if (local.reminderDate != remote.reminderDate) return false;
    if (local.notes != remote.notes) return false;
    if (local.budget != remote.budget) return false;
    if (local.assignedPerson != remote.assignedPerson) return false;
    
    // Compare custom fields
    final localMap = local.customFields ?? {};
    final remoteMap = remote.customFields ?? {};
    if (localMap.length != remoteMap.length) return false;
    for (final key in localMap.keys) {
      if (localMap[key] != remoteMap[key]) return false;
    }
    return true;
  }

  Future<excel_models.Lead> _dbLeadToExcelLead(Lead localLead) async {
    return excel_models.Lead(
      id: localLead.id,
      clientName: localLead.clientName,
      phoneNumber: localLead.phoneNumber,
      email: localLead.email,
      eventType: localLead.eventType,
      eventDate: localLead.eventDate,
      leadSource: localLead.leadSource,
      status: localLead.status,
      lastContactDate: localLead.lastContactDate,
      nextFollowUpDate: localLead.nextFollowUpDate,
      reminderDate: localLead.reminderDate,
      notes: localLead.notes,
      budget: localLead.budget,
      assignedPerson: localLead.assignedPerson,
      customFields: localLead.customFields,
    );
  }
}
