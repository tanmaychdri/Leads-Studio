import 'package:drift/drift.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/database/data/daos/leads_dao.dart';
import 'package:uuid/uuid.dart';
import 'package:leads_studio/features/notifications/domain/notification_scheduler.dart';

class LeadService {
  Future<void> reconcileAllNotifications() async {
    final allLeads = await _leadsDao.select(_leadsDao.leads).get();
    for (final lead in allLeads) {
      await _scheduler.rescheduleLeadNotifications(lead);
    }
    await _scheduler.reconcileDailySummaries(allLeads);
  }

  Future<void> _reconcileSummaries() async {
    final allLeads = await _leadsDao.select(_leadsDao.leads).get();
    await _scheduler.reconcileDailySummaries(allLeads);
  }
  final LeadsDao _leadsDao;
  final _uuid = const Uuid();
  final ReminderScheduler _scheduler = ReminderScheduler();

  LeadService(this._leadsDao);

  Stream<List<Lead>> watchLeads(String userId) {
    return _leadsDao.watchLeads(userId);
  }

  Stream<List<Lead>> watchFollowUps(String userId) {
    return _leadsDao.watchFollowUps(userId);
  }
  
    // --- Phase 7 Follow-up Queries ---
  
  Stream<List<Lead>> watchOverdueFollowUps(String userId) {
    return _leadsDao.watchOverdueFollowUps(userId);
  }

  Stream<List<Lead>> watchTodayFollowUps(String userId) {
    return _leadsDao.watchTodayFollowUps(userId);
  }

  Stream<List<Lead>> watchUpcomingFollowUps(String userId) {
    return _leadsDao.watchUpcomingFollowUps(userId);
  }

  Stream<List<Lead>> watchNeedsScheduling(String userId) {
    return _leadsDao.watchNeedsScheduling(userId);
  }

  Stream<List<Lead>> watchAllActiveLeads(String userId) {
    return _leadsDao.watchAllActiveLeads(userId);
  }

  Future<Lead> getLeadById(String id) async {
    final query = _leadsDao.select(_leadsDao.leads)..where((tbl) => tbl.id.equals(id));
    return await query.getSingle();
  }

  Future<void> createLead({
    required String userId,
    required String clientName,
    required String phoneNumber,
    String? email,
    String? eventType,
    DateTime? eventDate,
    String? status,
    DateTime? nextFollowUpDate,
    DateTime? reminderDate,
    String? notes,
    Map<String, dynamic> customFields = const {},
  }) async {
    final now = DateTime.now();
    final newId = _uuid.v4();
    final companion = LeadsCompanion.insert(
      id: newId,
      userId: userId,
      clientName: Value(clientName),
      phoneNumber: Value(phoneNumber),
      email: Value(email),
      eventType: Value(eventType),
      eventDate: Value(eventDate),
      status: Value(status ?? 'New'),
      nextFollowUpDate: Value(nextFollowUpDate),
      reminderDate: Value(reminderDate),
      notes: Value(notes),
      customFields: customFields,
      syncStatus: const Value('created'),
      isDeleted: const Value(false),
      createdAt: now,
      updatedAt: now,
    );

    await _leadsDao.upsertLead(companion);
    
    // Schedule notifications
    final newLead = await getLeadById(newId);
    await _scheduler.rescheduleLeadNotifications(newLead);
    await _reconcileSummaries();
  }

  Future<void> updateLead(
    Lead existingLead, {
    String? clientName,
    String? phoneNumber,
    String? email,
    String? eventType,
    DateTime? eventDate,
    String? status,
    DateTime? nextFollowUpDate,
    DateTime? reminderDate,
    String? notes,
    Map<String, dynamic>? customFields,
  }) async {
    final companion = LeadsCompanion(
      id: Value(existingLead.id),
      userId: Value(existingLead.userId),
      createdAt: Value(existingLead.createdAt),
      clientName: Value(clientName ?? existingLead.clientName),
      phoneNumber: Value(phoneNumber ?? existingLead.phoneNumber),
      email: Value(email ?? existingLead.email),
      eventType: Value(eventType ?? existingLead.eventType),
      eventDate: Value(eventDate ?? existingLead.eventDate),
      status: Value(status ?? existingLead.status),
      nextFollowUpDate: Value(nextFollowUpDate ?? existingLead.nextFollowUpDate),
      reminderDate: Value(reminderDate ?? existingLead.reminderDate),
      notes: Value(notes ?? existingLead.notes),
      customFields: Value(customFields ?? existingLead.customFields),
      syncStatus: const Value('updated'),
      updatedAt: Value(DateTime.now()),
    );

    await _leadsDao.upsertLead(companion);
    
    // Reschedule notifications
    final updatedLead = await getLeadById(existingLead.id);
    await _scheduler.rescheduleLeadNotifications(updatedLead);
    await _reconcileSummaries();
  }
  
  Future<void> updateLeadStatus(String leadId, String newStatus) async {
    await (_leadsDao.update(_leadsDao.leads)..where((tbl) => tbl.id.equals(leadId))).write(
      LeadsCompanion(
        status: Value(newStatus),
        syncStatus: const Value('updated'),
        updatedAt: Value(DateTime.now()),
      ),
    );
    
    final updatedLead = await getLeadById(leadId);
    await _scheduler.rescheduleLeadNotifications(updatedLead);
    await _reconcileSummaries();
  }

  Future<void> deleteLead(String id) async {
    await _leadsDao.softDeleteLead(id);
    await _scheduler.cancelLeadNotifications(id);
    await _reconcileSummaries();
  }
}