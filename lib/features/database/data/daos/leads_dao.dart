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
    // --- PHASE 7 INTELLIGENCE QUERIES ---

  Expression<bool> get _isActiveCondition {
    return leads.isDeleted.equals(false) &
           leads.status.isNotIn(['Converted', 'Lost', 'converted', 'lost']);
  }

  /// Watch Overdue Follow-ups
  Stream<List<Lead>> watchOverdueFollowUps(String userId) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    return (select(leads)
          ..where((tbl) =>
              tbl.userId.equals(userId) &
              _isActiveCondition &
              tbl.nextFollowUpDate.isNotNull() &
              tbl.nextFollowUpDate.isSmallerThanValue(startOfToday))
          ..orderBy([(t) => OrderingTerm.asc(t.nextFollowUpDate)]))
        .watch();
  }

  /// Watch Today's Follow-ups
  Stream<List<Lead>> watchTodayFollowUps(String userId) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return (select(leads)
          ..where((tbl) =>
              tbl.userId.equals(userId) &
              _isActiveCondition &
              tbl.nextFollowUpDate.isNotNull() &
              tbl.nextFollowUpDate.isBiggerOrEqualValue(startOfToday) &
              tbl.nextFollowUpDate.isSmallerOrEqualValue(endOfToday))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  /// Watch Upcoming Follow-ups (Tomorrow onwards)
  Stream<List<Lead>> watchUpcomingFollowUps(String userId) {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return (select(leads)
          ..where((tbl) =>
              tbl.userId.equals(userId) &
              _isActiveCondition &
              tbl.nextFollowUpDate.isNotNull() &
              tbl.nextFollowUpDate.isBiggerThanValue(endOfToday))
          ..orderBy([(t) => OrderingTerm.asc(t.nextFollowUpDate)]))
        .watch();
  }

  /// Watch Needs Scheduling (Active leads with no follow-up)
  Stream<List<Lead>> watchNeedsScheduling(String userId) {
    return (select(leads)
          ..where((tbl) =>
              tbl.userId.equals(userId) &
              _isActiveCondition &
              tbl.nextFollowUpDate.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  /// Watch All Active Leads (For Stats/Dashboard)
  Stream<List<Lead>> watchAllActiveLeads(String userId) {
    return (select(leads)
          ..where((tbl) => tbl.userId.equals(userId) & tbl.isDeleted.equals(false)))
        .watch();
  }

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