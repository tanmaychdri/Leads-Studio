import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:leads_studio/features/database/data/tables/leads_table.dart';
import 'package:leads_studio/features/database/data/tables/spreadsheet_metadata_table.dart';
import 'package:leads_studio/features/database/data/daos/leads_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Leads, SpreadsheetMetadata], daos: [LeadsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'leads_studio_data', 'leads_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}