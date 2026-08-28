import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/database/data/daos/leads_dao.dart';
import 'package:leads_studio/features/database/presentation/providers/database_provider.dart';
import 'package:leads_studio/features/excel/data/models/parse_result.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/drive/presentation/providers/drive_provider.dart';

final excelImportServiceProvider = Provider((ref) {
  final dao = ref.watch(leadsDaoProvider);
  final db = ref.watch(appDatabaseProvider);
  final auth = ref.watch(authProvider);
  final drive = ref.watch(driveProvider);
  return ExcelImportService(dao, db, auth.user?.id, drive.connectedFile?.fileId);
});

class ImportSummary {
  final int totalAttempted;
  final int successfullyImported;
  final int skippedDueToLocalChanges;

  ImportSummary({
    required this.totalAttempted,
    required this.successfullyImported,
    required this.skippedDueToLocalChanges,
  });
}

class ExcelImportService {
  final LeadsDao _dao;
  final AppDatabase _db;
  final String? _userId;
  final String? _fileId;

  ExcelImportService(this._dao, this._db, this._userId, this._fileId);

  Future<ImportSummary> importParseResult(ParseResult result, String worksheetName) async {
    if (_userId == null) throw Exception('Cannot import data: User not logged in.');
    if (_fileId == null) throw Exception('Cannot import data: No connected file ID.');

    int successCount = 0;
    int skippedCount = 0;

    await _db.transaction(() async {
      // 1. Get all current leads for this user to check sync status
      final currentLeads = await _dao.getLeads(_userId!);
      final localMap = {for (var l in currentLeads) l.id: l};

      // 2. Upsert parsed leads
      for (final leadModel in result.leads) {
        final existingLocal = localMap[leadModel.id];

        // Safe Refresh Protection: Do NOT overwrite if local is unsynchronized
        if (existingLocal != null && existingLocal.syncStatus == 'updated') {
          skippedCount++;
          continue; 
        }

        final companion = LeadsCompanion(
          id: Value(leadModel.id),
          userId: Value(_userId!),
          clientName: Value(leadModel.clientName),
          phoneNumber: Value(leadModel.phoneNumber),
          email: Value(leadModel.email),
          eventType: Value(leadModel.eventType),
          eventDate: Value(leadModel.eventDate),
          leadSource: Value(leadModel.leadSource),
          status: Value(leadModel.status),
          lastContactDate: Value(leadModel.lastContactDate),
          nextFollowUpDate: Value(leadModel.nextFollowUpDate),
          reminderDate: Value(leadModel.reminderDate),
          notes: Value(leadModel.notes),
          budget: Value(leadModel.budget),
          assignedPerson: Value(leadModel.assignedPerson),
          customFields: Value(leadModel.customFields),
          createdAt: existingLocal != null ? Value(existingLocal.createdAt) : Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value('synced'), // Represents data exactly matching the spreadsheet
          isDeleted: const Value(false),
        );

        await _db.into(_db.leads).insertOnConflictUpdate(companion);
        successCount++;
      }

      // 3. Update Spreadsheet Metadata
      await _db.into(_db.spreadsheetMetadata).insertOnConflictUpdate(
        SpreadsheetMetadataCompanion(
          userId: Value(_userId!),
          fileId: Value(_fileId!),
          worksheetName: Value(worksheetName),
          lastImportedAt: Value(DateTime.now()),
        ),
      );
    });

    return ImportSummary(
      totalAttempted: result.leads.length,
      successfullyImported: successCount,
      skippedDueToLocalChanges: skippedCount,
    );
  }
}