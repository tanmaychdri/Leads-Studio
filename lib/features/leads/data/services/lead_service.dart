import 'package:drift/drift.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/database/data/daos/leads_dao.dart';
import 'package:uuid/uuid.dart';

class LeadService {
  final LeadsDao _leadsDao;
  final _uuid = const Uuid();

  LeadService(this._leadsDao);

  Stream<List<Lead>> watchLeads(String userId) {
    return _leadsDao.watchLeads(userId);
  }

  Stream<List<Lead>> watchFollowUps(String userId) {
    return _leadsDao.watchFollowUps(userId);
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
    String? notes,
    Map<String, dynamic> customFields = const {},
  }) async {
    final now = DateTime.now();
    final companion = LeadsCompanion.insert(
      id: _uuid.v4(),
      userId: userId,
      clientName: Value(clientName),
      phoneNumber: Value(phoneNumber),
      email: Value(email),
      eventType: Value(eventType),
      eventDate: Value(eventDate),
      status: Value(status ?? 'New'),
      nextFollowUpDate: Value(nextFollowUpDate),
      notes: Value(notes),
      customFields: customFields,
      syncStatus: const Value('created'),
      isDeleted: const Value(false),
      createdAt: now,
      updatedAt: now,
    );

    await _leadsDao.upsertLead(companion);
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
    String? notes,
    Map<String, dynamic>? customFields,
  }) async {
    final companion = LeadsCompanion(
      id: Value(existingLead.id),
      clientName: Value(clientName ?? existingLead.clientName),
      phoneNumber: Value(phoneNumber ?? existingLead.phoneNumber),
      email: Value(email ?? existingLead.email),
      eventType: Value(eventType ?? existingLead.eventType),
      eventDate: Value(eventDate ?? existingLead.eventDate),
      status: Value(status ?? existingLead.status),
      nextFollowUpDate: Value(nextFollowUpDate ?? existingLead.nextFollowUpDate),
      notes: Value(notes ?? existingLead.notes),
      customFields: Value(customFields ?? existingLead.customFields),
      syncStatus: const Value('updated'),
      updatedAt: Value(DateTime.now()),
    );

    await _leadsDao.upsertLead(companion);
  }
  
  Future<void> updateLeadStatus(String leadId, String newStatus) async {
    await (_leadsDao.update(_leadsDao.leads)..where((tbl) => tbl.id.equals(leadId))).write(
      LeadsCompanion(
        status: Value(newStatus),
        syncStatus: const Value('updated'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteLead(String id) async {
    await _leadsDao.softDeleteLead(id);
  }
}