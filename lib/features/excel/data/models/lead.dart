import 'package:uuid/uuid.dart';

class Lead {
  final String id;
  final String? clientName;
  final String? phoneNumber;
  final String? email;
  final String? eventType;
  final DateTime? eventDate;
  final String? leadSource;
  final String? status;
  final DateTime? lastContactDate;
  final DateTime? nextFollowUpDate;
  final DateTime? reminderDate;
  final String? notes;
  final double? budget;
  final String? assignedPerson;
  final Map<String, dynamic> customFields;

  Lead({
    String? id,
    this.clientName,
    this.phoneNumber,
    this.email,
    this.eventType,
    this.eventDate,
    this.leadSource,
    this.status,
    this.lastContactDate,
    this.nextFollowUpDate,
    this.reminderDate,
    this.notes,
    this.budget,
    this.assignedPerson,
    Map<String, dynamic>? customFields,
  })  : id = id ?? const Uuid().v4(),
        customFields = customFields ?? const {};

  Lead copyWith({
    String? id,
    String? clientName,
    String? phoneNumber,
    String? email,
    String? eventType,
    DateTime? eventDate,
    String? leadSource,
    String? status,
    DateTime? lastContactDate,
    DateTime? nextFollowUpDate,
    DateTime? reminderDate,
    String? notes,
    double? budget,
    String? assignedPerson,
    Map<String, dynamic>? customFields,
  }) {
    return Lead(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      eventType: eventType ?? this.eventType,
      eventDate: eventDate ?? this.eventDate,
      leadSource: leadSource ?? this.leadSource,
      status: status ?? this.status,
      lastContactDate: lastContactDate ?? this.lastContactDate,
      nextFollowUpDate: nextFollowUpDate ?? this.nextFollowUpDate,
      reminderDate: reminderDate ?? this.reminderDate,
      notes: notes ?? this.notes,
      budget: budget ?? this.budget,
      assignedPerson: assignedPerson ?? this.assignedPerson,
      customFields: customFields ?? this.customFields,
    );
  }
}