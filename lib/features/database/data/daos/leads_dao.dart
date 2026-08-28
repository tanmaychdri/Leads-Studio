import 'package:drift/drift.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/database/data/tables/leads_table.dart';

part 'leads_dao.g.dart';

@DriftAccessor(tables: [Leads])
class LeadsDao extends DatabaseAccessor<AppDatabase> with _$LeadsDaoMixin {
  LeadsDao(AppDatabase db) : super(db);

  /// Fetch all non-deleted leads for a specific user
  Future<List<Lead>> getLeads(String userId) {
    return (select(leads)
          ..where((tbl) => tbl.userId.equals(userId) & tbl.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  /// Watch all non-deleted leads for a specific user (Reactive)
  Stream<List<Lead>> watchLeads(String userId) {
    return (select(leads)
          ..where((tbl) => tbl.userId.equals(userId) & tbl.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  /// Fetch leads with a follow-up today (or past due)
  Stream<List<Lead>> watchFollowUps(String userId) {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return (select(leads)
          ..where((tbl) =>
              tbl.userId.equals(userId) &
              tbl.isDeleted.equals(false) &
              tbl.nextFollowUpDate.isNotNull() &
              tbl.nextFollowUpDate.isSmallerOrEqualValue(endOfToday))
          ..orderBy([(t) => OrderingTerm.asc(t.nextFollowUpDate)]))
        .watch();
  }

  /// Insert or update a lead
  Future<void> upsertLead(Insertable<Lead> lead) {
    return into(leads).insertOnConflictUpdate(lead);
  }

  /// Soft delete a lead (mark as deleted)
  Future<void> softDeleteLead(String id) {
    return (update(leads)..where((tbl) => tbl.id.equals(id))).write(
      LeadsCompanion(
        isDeleted: const Value(true),
        syncStatus: const Value('deleted'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete all leads for a user (local device wipe)
  Future<void> wipeUserData(String userId) {
    return (delete(leads)..where((tbl) => tbl.userId.equals(userId))).go();
  }
}