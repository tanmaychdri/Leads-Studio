import 'package:drift/drift.dart';

class SpreadsheetMetadata extends Table {
  TextColumn get userId => text()(); // Links to the user
  TextColumn get fileId => text()(); // Google Drive File ID
  TextColumn get worksheetName => text()(); // The sheet name used
  
  DateTimeColumn get lastImportedAt => dateTime()();
  DateTimeColumn get lastKnownRemoteModifiedTime => dateTime().nullable()();
  
  @override
  Set<Column> get primaryKey => {userId}; // 1 active spreadsheet per user
}