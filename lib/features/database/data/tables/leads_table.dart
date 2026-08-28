import 'dart:convert';
import 'package:drift/drift.dart';

class CustomFieldsConverter extends TypeConverter<Map<String, dynamic>, String> {
  const CustomFieldsConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    return json.decode(fromDb) as Map<String, dynamic>;
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return json.encode(value);
  }
}

class Leads extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  
  // Core Data
  TextColumn get clientName => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get eventType => text().nullable()();
  DateTimeColumn get eventDate => dateTime().nullable()();
  TextColumn get leadSource => text().nullable()();
  TextColumn get status => text().nullable()();
  DateTimeColumn get lastContactDate => dateTime().nullable()();
  DateTimeColumn get nextFollowUpDate => dateTime().nullable()();
  DateTimeColumn get reminderDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  RealColumn get budget => real().nullable()();
  TextColumn get assignedPerson => text().nullable()();
  
  // Custom Fields (Stored as JSON String)
  TextColumn get customFields => text().map(const CustomFieldsConverter())();
  
  // Sync & Audit Metadata
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('created'))(); // 'created', 'updated', 'deleted', 'synced'
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}