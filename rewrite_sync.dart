import 'dart:io';

void main() {
  final file = File('lib/core/sync/sync_engine.dart');
  var content = file.readAsStringSync();

  final triggerSyncRegex = RegExp(r'Future<void> triggerSync\(\) async \{[\s\S]*?^\s*\}', multiLine: true);
  
  final newTriggerSync = '''
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
      final localSavePath = '\/sync_temp_workbook.xlsx';
      
      await driveService.downloadFile(fileId, localSavePath);
      await excelService.loadWorkbook(localSavePath);
      
      List<SyncConflict> conflicts = [];
      
      final parseResult = await excelService.parseWorksheet(metadata.worksheetName);
      if (parseResult.error != null) {
        throw Exception('Failed to parse remote worksheet: \');
      }

      final remoteLeadsMap = {for (var lead in parseResult.leads) lead.id: lead};
      
      // Get all local leads that are synced (not pending) for deletion checking
      final allLocalLeads = await db.select(db.leads).get();

      // Phase 1: Pull & Conflict Detection
      for (var remoteLead in parseResult.leads) {
        var localLead = await (db.select(db.leads)..where((tbl) => tbl.id.equals(remoteLead.id))).getSingleOrNull();
        
        bool isIdSeedingRequired = false;
        if (localLead == null && (remoteLead.clientName != null || remoteLead.phoneNumber != null)) {
          localLead = await (db.select(db.leads)
            ..where((tbl) {
              Expression<bool> nameCond = remoteLead.clientName == null ? tbl.clientName.isNull() : tbl.clientName.equals(remoteLead.clientName!);
              Expression<bool> phoneCond = remoteLead.phoneNumber == null ? tbl.phoneNumber.isNull() : tbl.phoneNumber.equals(remoteLead.phoneNumber!);
              return nameCond & phoneCond;
            }))
            .getSingleOrNull();
          
          if (localLead != null) {
             isIdSeedingRequired = true;
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
                remoteData: {'status': remoteLead.status, 'notes': remoteLead.notes}, 
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
            await (db.update(db.leads)..where((tbl) => tbl.id.equals(safeLocalLead.id))).write(const LeadsCompanion(syncStatus: Value('updated')));
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
            syncStatus: const Value('updated'),
          ));
          
          final insertedLead = await (db.select(db.leads)..where((tbl) => tbl.id.equals(remoteLead.id))).getSingle();
          pendingChanges.add(insertedLead);
        }
      }

      // Phase 1.5: Remote Deletions
      for (var localLead in allLocalLeads) {
        if (!remoteLeadsMap.containsKey(localLead.id)) {
          if (!localPendingMap.containsKey(localLead.id)) {
             await (db.delete(db.leads)..where((tbl) => tbl.id.equals(localLead.id))).go();
          }
        }
      }

      if (conflicts.isNotEmpty) {
        ref.read(syncStateProvider.notifier).state = state.copyWith(
          status: SyncStatus.conflict,
          activeConflicts: conflicts,
        );
        return; 
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
      
      if (pendingChanges.isNotEmpty) {
        for (var localLead in pendingChanges) {
          if (localLead.isDeleted) {
             await (db.delete(db.leads)..where((tbl) => tbl.id.equals(localLead.id))).go();
          } else {
             await (db.update(db.leads)..where((tbl) => tbl.id.equals(localLead.id))).write(const LeadsCompanion(syncStatus: Value('synced')));
          }
        }
      }

      final updatedFileMeta = await driveService.getFileMetadata(fileId);
      final finalRemoteTime = updatedFileMeta?.modifiedTime ?? DateTime.now();

      await db.update(db.spreadsheetMetadata).replace(metadata.copyWith(
        lastKnownRemoteModifiedTime: Value(finalRemoteTime),
        lastSuccessfulSyncAt: Value(DateTime.now()),
      ));

      ref.read(syncStateProvider.notifier).state = state.copyWith(
        status: SyncStatus.success,
        lastSyncTime: DateTime.now(),
        pendingChangesCount: 0,
        activeConflicts: null,
        resolvedLocalWins: {}, 
      );
      
    } catch (e) {
      ref.read(syncStateProvider.notifier).state = state.copyWith(
        status: SyncStatus.failed,
        errorMessage: e.toString(),
      );
    }
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
    
    final localMap = local.customFields ?? {};
    final remoteMap = remote.customFields ?? {};
    if (localMap.length != remoteMap.length) return false;
    for (final key in localMap.keys) {
      if (localMap[key] != remoteMap[key]) return false;
    }
    return true;
  }
''';

  content = content.replaceFirst(triggerSyncRegex, newTriggerSync);
  file.writeAsStringSync(content);
  print('Rewritten');
}
