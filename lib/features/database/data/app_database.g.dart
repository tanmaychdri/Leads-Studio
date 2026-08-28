// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LeadsTable extends Leads with TableInfo<$LeadsTable, Lead> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientNameMeta = const VerificationMeta(
    'clientName',
  );
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
    'client_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventDateMeta = const VerificationMeta(
    'eventDate',
  );
  @override
  late final GeneratedColumn<DateTime> eventDate = GeneratedColumn<DateTime>(
    'event_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leadSourceMeta = const VerificationMeta(
    'leadSource',
  );
  @override
  late final GeneratedColumn<String> leadSource = GeneratedColumn<String>(
    'lead_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastContactDateMeta = const VerificationMeta(
    'lastContactDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastContactDate =
      GeneratedColumn<DateTime>(
        'last_contact_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextFollowUpDateMeta = const VerificationMeta(
    'nextFollowUpDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextFollowUpDate =
      GeneratedColumn<DateTime>(
        'next_follow_up_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _reminderDateMeta = const VerificationMeta(
    'reminderDate',
  );
  @override
  late final GeneratedColumn<DateTime> reminderDate = GeneratedColumn<DateTime>(
    'reminder_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<double> budget = GeneratedColumn<double>(
    'budget',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assignedPersonMeta = const VerificationMeta(
    'assignedPerson',
  );
  @override
  late final GeneratedColumn<String> assignedPerson = GeneratedColumn<String>(
    'assigned_person',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  customFields = GeneratedColumn<String>(
    'custom_fields',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, dynamic>>($LeadsTable.$convertercustomFields);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('created'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    clientName,
    phoneNumber,
    email,
    eventType,
    eventDate,
    leadSource,
    status,
    lastContactDate,
    nextFollowUpDate,
    reminderDate,
    notes,
    budget,
    assignedPerson,
    customFields,
    createdAt,
    updatedAt,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leads';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lead> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('client_name')) {
      context.handle(
        _clientNameMeta,
        clientName.isAcceptableOrUnknown(data['client_name']!, _clientNameMeta),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    }
    if (data.containsKey('event_date')) {
      context.handle(
        _eventDateMeta,
        eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta),
      );
    }
    if (data.containsKey('lead_source')) {
      context.handle(
        _leadSourceMeta,
        leadSource.isAcceptableOrUnknown(data['lead_source']!, _leadSourceMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('last_contact_date')) {
      context.handle(
        _lastContactDateMeta,
        lastContactDate.isAcceptableOrUnknown(
          data['last_contact_date']!,
          _lastContactDateMeta,
        ),
      );
    }
    if (data.containsKey('next_follow_up_date')) {
      context.handle(
        _nextFollowUpDateMeta,
        nextFollowUpDate.isAcceptableOrUnknown(
          data['next_follow_up_date']!,
          _nextFollowUpDateMeta,
        ),
      );
    }
    if (data.containsKey('reminder_date')) {
      context.handle(
        _reminderDateMeta,
        reminderDate.isAcceptableOrUnknown(
          data['reminder_date']!,
          _reminderDateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('budget')) {
      context.handle(
        _budgetMeta,
        budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta),
      );
    }
    if (data.containsKey('assigned_person')) {
      context.handle(
        _assignedPersonMeta,
        assignedPerson.isAcceptableOrUnknown(
          data['assigned_person']!,
          _assignedPersonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lead map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lead(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      clientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_name'],
      ),
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      ),
      eventDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}event_date'],
      ),
      leadSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lead_source'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      lastContactDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_contact_date'],
      ),
      nextFollowUpDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_follow_up_date'],
      ),
      reminderDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      budget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}budget'],
      ),
      assignedPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_person'],
      ),
      customFields: $LeadsTable.$convertercustomFields.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}custom_fields'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $LeadsTable createAlias(String alias) {
    return $LeadsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $convertercustomFields =
      const CustomFieldsConverter();
}

class Lead extends DataClass implements Insertable<Lead> {
  final String id;
  final String userId;
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final bool isDeleted;
  const Lead({
    required this.id,
    required this.userId,
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
    required this.customFields,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || clientName != null) {
      map['client_name'] = Variable<String>(clientName);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || eventType != null) {
      map['event_type'] = Variable<String>(eventType);
    }
    if (!nullToAbsent || eventDate != null) {
      map['event_date'] = Variable<DateTime>(eventDate);
    }
    if (!nullToAbsent || leadSource != null) {
      map['lead_source'] = Variable<String>(leadSource);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || lastContactDate != null) {
      map['last_contact_date'] = Variable<DateTime>(lastContactDate);
    }
    if (!nullToAbsent || nextFollowUpDate != null) {
      map['next_follow_up_date'] = Variable<DateTime>(nextFollowUpDate);
    }
    if (!nullToAbsent || reminderDate != null) {
      map['reminder_date'] = Variable<DateTime>(reminderDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || budget != null) {
      map['budget'] = Variable<double>(budget);
    }
    if (!nullToAbsent || assignedPerson != null) {
      map['assigned_person'] = Variable<String>(assignedPerson);
    }
    {
      map['custom_fields'] = Variable<String>(
        $LeadsTable.$convertercustomFields.toSql(customFields),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  LeadsCompanion toCompanion(bool nullToAbsent) {
    return LeadsCompanion(
      id: Value(id),
      userId: Value(userId),
      clientName: clientName == null && nullToAbsent
          ? const Value.absent()
          : Value(clientName),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      eventType: eventType == null && nullToAbsent
          ? const Value.absent()
          : Value(eventType),
      eventDate: eventDate == null && nullToAbsent
          ? const Value.absent()
          : Value(eventDate),
      leadSource: leadSource == null && nullToAbsent
          ? const Value.absent()
          : Value(leadSource),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      lastContactDate: lastContactDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastContactDate),
      nextFollowUpDate: nextFollowUpDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextFollowUpDate),
      reminderDate: reminderDate == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      budget: budget == null && nullToAbsent
          ? const Value.absent()
          : Value(budget),
      assignedPerson: assignedPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedPerson),
      customFields: Value(customFields),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory Lead.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lead(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      clientName: serializer.fromJson<String?>(json['clientName']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      email: serializer.fromJson<String?>(json['email']),
      eventType: serializer.fromJson<String?>(json['eventType']),
      eventDate: serializer.fromJson<DateTime?>(json['eventDate']),
      leadSource: serializer.fromJson<String?>(json['leadSource']),
      status: serializer.fromJson<String?>(json['status']),
      lastContactDate: serializer.fromJson<DateTime?>(json['lastContactDate']),
      nextFollowUpDate: serializer.fromJson<DateTime?>(
        json['nextFollowUpDate'],
      ),
      reminderDate: serializer.fromJson<DateTime?>(json['reminderDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      budget: serializer.fromJson<double?>(json['budget']),
      assignedPerson: serializer.fromJson<String?>(json['assignedPerson']),
      customFields: serializer.fromJson<Map<String, dynamic>>(
        json['customFields'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'clientName': serializer.toJson<String?>(clientName),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'email': serializer.toJson<String?>(email),
      'eventType': serializer.toJson<String?>(eventType),
      'eventDate': serializer.toJson<DateTime?>(eventDate),
      'leadSource': serializer.toJson<String?>(leadSource),
      'status': serializer.toJson<String?>(status),
      'lastContactDate': serializer.toJson<DateTime?>(lastContactDate),
      'nextFollowUpDate': serializer.toJson<DateTime?>(nextFollowUpDate),
      'reminderDate': serializer.toJson<DateTime?>(reminderDate),
      'notes': serializer.toJson<String?>(notes),
      'budget': serializer.toJson<double?>(budget),
      'assignedPerson': serializer.toJson<String?>(assignedPerson),
      'customFields': serializer.toJson<Map<String, dynamic>>(customFields),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Lead copyWith({
    String? id,
    String? userId,
    Value<String?> clientName = const Value.absent(),
    Value<String?> phoneNumber = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> eventType = const Value.absent(),
    Value<DateTime?> eventDate = const Value.absent(),
    Value<String?> leadSource = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<DateTime?> lastContactDate = const Value.absent(),
    Value<DateTime?> nextFollowUpDate = const Value.absent(),
    Value<DateTime?> reminderDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<double?> budget = const Value.absent(),
    Value<String?> assignedPerson = const Value.absent(),
    Map<String, dynamic>? customFields,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    bool? isDeleted,
  }) => Lead(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    clientName: clientName.present ? clientName.value : this.clientName,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    email: email.present ? email.value : this.email,
    eventType: eventType.present ? eventType.value : this.eventType,
    eventDate: eventDate.present ? eventDate.value : this.eventDate,
    leadSource: leadSource.present ? leadSource.value : this.leadSource,
    status: status.present ? status.value : this.status,
    lastContactDate: lastContactDate.present
        ? lastContactDate.value
        : this.lastContactDate,
    nextFollowUpDate: nextFollowUpDate.present
        ? nextFollowUpDate.value
        : this.nextFollowUpDate,
    reminderDate: reminderDate.present ? reminderDate.value : this.reminderDate,
    notes: notes.present ? notes.value : this.notes,
    budget: budget.present ? budget.value : this.budget,
    assignedPerson: assignedPerson.present
        ? assignedPerson.value
        : this.assignedPerson,
    customFields: customFields ?? this.customFields,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Lead copyWithCompanion(LeadsCompanion data) {
    return Lead(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      clientName: data.clientName.present
          ? data.clientName.value
          : this.clientName,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      email: data.email.present ? data.email.value : this.email,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      leadSource: data.leadSource.present
          ? data.leadSource.value
          : this.leadSource,
      status: data.status.present ? data.status.value : this.status,
      lastContactDate: data.lastContactDate.present
          ? data.lastContactDate.value
          : this.lastContactDate,
      nextFollowUpDate: data.nextFollowUpDate.present
          ? data.nextFollowUpDate.value
          : this.nextFollowUpDate,
      reminderDate: data.reminderDate.present
          ? data.reminderDate.value
          : this.reminderDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      budget: data.budget.present ? data.budget.value : this.budget,
      assignedPerson: data.assignedPerson.present
          ? data.assignedPerson.value
          : this.assignedPerson,
      customFields: data.customFields.present
          ? data.customFields.value
          : this.customFields,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lead(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientName: $clientName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('eventType: $eventType, ')
          ..write('eventDate: $eventDate, ')
          ..write('leadSource: $leadSource, ')
          ..write('status: $status, ')
          ..write('lastContactDate: $lastContactDate, ')
          ..write('nextFollowUpDate: $nextFollowUpDate, ')
          ..write('reminderDate: $reminderDate, ')
          ..write('notes: $notes, ')
          ..write('budget: $budget, ')
          ..write('assignedPerson: $assignedPerson, ')
          ..write('customFields: $customFields, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    clientName,
    phoneNumber,
    email,
    eventType,
    eventDate,
    leadSource,
    status,
    lastContactDate,
    nextFollowUpDate,
    reminderDate,
    notes,
    budget,
    assignedPerson,
    customFields,
    createdAt,
    updatedAt,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lead &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.clientName == this.clientName &&
          other.phoneNumber == this.phoneNumber &&
          other.email == this.email &&
          other.eventType == this.eventType &&
          other.eventDate == this.eventDate &&
          other.leadSource == this.leadSource &&
          other.status == this.status &&
          other.lastContactDate == this.lastContactDate &&
          other.nextFollowUpDate == this.nextFollowUpDate &&
          other.reminderDate == this.reminderDate &&
          other.notes == this.notes &&
          other.budget == this.budget &&
          other.assignedPerson == this.assignedPerson &&
          other.customFields == this.customFields &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class LeadsCompanion extends UpdateCompanion<Lead> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> clientName;
  final Value<String?> phoneNumber;
  final Value<String?> email;
  final Value<String?> eventType;
  final Value<DateTime?> eventDate;
  final Value<String?> leadSource;
  final Value<String?> status;
  final Value<DateTime?> lastContactDate;
  final Value<DateTime?> nextFollowUpDate;
  final Value<DateTime?> reminderDate;
  final Value<String?> notes;
  final Value<double?> budget;
  final Value<String?> assignedPerson;
  final Value<Map<String, dynamic>> customFields;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const LeadsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.clientName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.eventType = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.leadSource = const Value.absent(),
    this.status = const Value.absent(),
    this.lastContactDate = const Value.absent(),
    this.nextFollowUpDate = const Value.absent(),
    this.reminderDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.budget = const Value.absent(),
    this.assignedPerson = const Value.absent(),
    this.customFields = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeadsCompanion.insert({
    required String id,
    required String userId,
    this.clientName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.eventType = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.leadSource = const Value.absent(),
    this.status = const Value.absent(),
    this.lastContactDate = const Value.absent(),
    this.nextFollowUpDate = const Value.absent(),
    this.reminderDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.budget = const Value.absent(),
    this.assignedPerson = const Value.absent(),
    required Map<String, dynamic> customFields,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       customFields = Value(customFields),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Lead> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? clientName,
    Expression<String>? phoneNumber,
    Expression<String>? email,
    Expression<String>? eventType,
    Expression<DateTime>? eventDate,
    Expression<String>? leadSource,
    Expression<String>? status,
    Expression<DateTime>? lastContactDate,
    Expression<DateTime>? nextFollowUpDate,
    Expression<DateTime>? reminderDate,
    Expression<String>? notes,
    Expression<double>? budget,
    Expression<String>? assignedPerson,
    Expression<String>? customFields,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (clientName != null) 'client_name': clientName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (email != null) 'email': email,
      if (eventType != null) 'event_type': eventType,
      if (eventDate != null) 'event_date': eventDate,
      if (leadSource != null) 'lead_source': leadSource,
      if (status != null) 'status': status,
      if (lastContactDate != null) 'last_contact_date': lastContactDate,
      if (nextFollowUpDate != null) 'next_follow_up_date': nextFollowUpDate,
      if (reminderDate != null) 'reminder_date': reminderDate,
      if (notes != null) 'notes': notes,
      if (budget != null) 'budget': budget,
      if (assignedPerson != null) 'assigned_person': assignedPerson,
      if (customFields != null) 'custom_fields': customFields,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeadsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? clientName,
    Value<String?>? phoneNumber,
    Value<String?>? email,
    Value<String?>? eventType,
    Value<DateTime?>? eventDate,
    Value<String?>? leadSource,
    Value<String?>? status,
    Value<DateTime?>? lastContactDate,
    Value<DateTime?>? nextFollowUpDate,
    Value<DateTime?>? reminderDate,
    Value<String?>? notes,
    Value<double?>? budget,
    Value<String?>? assignedPerson,
    Value<Map<String, dynamic>>? customFields,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? syncStatus,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return LeadsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<DateTime>(eventDate.value);
    }
    if (leadSource.present) {
      map['lead_source'] = Variable<String>(leadSource.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastContactDate.present) {
      map['last_contact_date'] = Variable<DateTime>(lastContactDate.value);
    }
    if (nextFollowUpDate.present) {
      map['next_follow_up_date'] = Variable<DateTime>(nextFollowUpDate.value);
    }
    if (reminderDate.present) {
      map['reminder_date'] = Variable<DateTime>(reminderDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (budget.present) {
      map['budget'] = Variable<double>(budget.value);
    }
    if (assignedPerson.present) {
      map['assigned_person'] = Variable<String>(assignedPerson.value);
    }
    if (customFields.present) {
      map['custom_fields'] = Variable<String>(
        $LeadsTable.$convertercustomFields.toSql(customFields.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeadsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('clientName: $clientName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('eventType: $eventType, ')
          ..write('eventDate: $eventDate, ')
          ..write('leadSource: $leadSource, ')
          ..write('status: $status, ')
          ..write('lastContactDate: $lastContactDate, ')
          ..write('nextFollowUpDate: $nextFollowUpDate, ')
          ..write('reminderDate: $reminderDate, ')
          ..write('notes: $notes, ')
          ..write('budget: $budget, ')
          ..write('assignedPerson: $assignedPerson, ')
          ..write('customFields: $customFields, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpreadsheetMetadataTable extends SpreadsheetMetadata
    with TableInfo<$SpreadsheetMetadataTable, SpreadsheetMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpreadsheetMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<String> fileId = GeneratedColumn<String>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worksheetNameMeta = const VerificationMeta(
    'worksheetName',
  );
  @override
  late final GeneratedColumn<String> worksheetName = GeneratedColumn<String>(
    'worksheet_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastImportedAtMeta = const VerificationMeta(
    'lastImportedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastImportedAt =
      GeneratedColumn<DateTime>(
        'last_imported_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastKnownRemoteModifiedTimeMeta =
      const VerificationMeta('lastKnownRemoteModifiedTime');
  @override
  late final GeneratedColumn<DateTime> lastKnownRemoteModifiedTime =
      GeneratedColumn<DateTime>(
        'last_known_remote_modified_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    fileId,
    worksheetName,
    lastImportedAt,
    lastKnownRemoteModifiedTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spreadsheet_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpreadsheetMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('worksheet_name')) {
      context.handle(
        _worksheetNameMeta,
        worksheetName.isAcceptableOrUnknown(
          data['worksheet_name']!,
          _worksheetNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_worksheetNameMeta);
    }
    if (data.containsKey('last_imported_at')) {
      context.handle(
        _lastImportedAtMeta,
        lastImportedAt.isAcceptableOrUnknown(
          data['last_imported_at']!,
          _lastImportedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastImportedAtMeta);
    }
    if (data.containsKey('last_known_remote_modified_time')) {
      context.handle(
        _lastKnownRemoteModifiedTimeMeta,
        lastKnownRemoteModifiedTime.isAcceptableOrUnknown(
          data['last_known_remote_modified_time']!,
          _lastKnownRemoteModifiedTimeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  SpreadsheetMetadataData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpreadsheetMetadataData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_id'],
      )!,
      worksheetName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worksheet_name'],
      )!,
      lastImportedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_imported_at'],
      )!,
      lastKnownRemoteModifiedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_known_remote_modified_time'],
      ),
    );
  }

  @override
  $SpreadsheetMetadataTable createAlias(String alias) {
    return $SpreadsheetMetadataTable(attachedDatabase, alias);
  }
}

class SpreadsheetMetadataData extends DataClass
    implements Insertable<SpreadsheetMetadataData> {
  final String userId;
  final String fileId;
  final String worksheetName;
  final DateTime lastImportedAt;
  final DateTime? lastKnownRemoteModifiedTime;
  const SpreadsheetMetadataData({
    required this.userId,
    required this.fileId,
    required this.worksheetName,
    required this.lastImportedAt,
    this.lastKnownRemoteModifiedTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['file_id'] = Variable<String>(fileId);
    map['worksheet_name'] = Variable<String>(worksheetName);
    map['last_imported_at'] = Variable<DateTime>(lastImportedAt);
    if (!nullToAbsent || lastKnownRemoteModifiedTime != null) {
      map['last_known_remote_modified_time'] = Variable<DateTime>(
        lastKnownRemoteModifiedTime,
      );
    }
    return map;
  }

  SpreadsheetMetadataCompanion toCompanion(bool nullToAbsent) {
    return SpreadsheetMetadataCompanion(
      userId: Value(userId),
      fileId: Value(fileId),
      worksheetName: Value(worksheetName),
      lastImportedAt: Value(lastImportedAt),
      lastKnownRemoteModifiedTime:
          lastKnownRemoteModifiedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastKnownRemoteModifiedTime),
    );
  }

  factory SpreadsheetMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpreadsheetMetadataData(
      userId: serializer.fromJson<String>(json['userId']),
      fileId: serializer.fromJson<String>(json['fileId']),
      worksheetName: serializer.fromJson<String>(json['worksheetName']),
      lastImportedAt: serializer.fromJson<DateTime>(json['lastImportedAt']),
      lastKnownRemoteModifiedTime: serializer.fromJson<DateTime?>(
        json['lastKnownRemoteModifiedTime'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'fileId': serializer.toJson<String>(fileId),
      'worksheetName': serializer.toJson<String>(worksheetName),
      'lastImportedAt': serializer.toJson<DateTime>(lastImportedAt),
      'lastKnownRemoteModifiedTime': serializer.toJson<DateTime?>(
        lastKnownRemoteModifiedTime,
      ),
    };
  }

  SpreadsheetMetadataData copyWith({
    String? userId,
    String? fileId,
    String? worksheetName,
    DateTime? lastImportedAt,
    Value<DateTime?> lastKnownRemoteModifiedTime = const Value.absent(),
  }) => SpreadsheetMetadataData(
    userId: userId ?? this.userId,
    fileId: fileId ?? this.fileId,
    worksheetName: worksheetName ?? this.worksheetName,
    lastImportedAt: lastImportedAt ?? this.lastImportedAt,
    lastKnownRemoteModifiedTime: lastKnownRemoteModifiedTime.present
        ? lastKnownRemoteModifiedTime.value
        : this.lastKnownRemoteModifiedTime,
  );
  SpreadsheetMetadataData copyWithCompanion(SpreadsheetMetadataCompanion data) {
    return SpreadsheetMetadataData(
      userId: data.userId.present ? data.userId.value : this.userId,
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      worksheetName: data.worksheetName.present
          ? data.worksheetName.value
          : this.worksheetName,
      lastImportedAt: data.lastImportedAt.present
          ? data.lastImportedAt.value
          : this.lastImportedAt,
      lastKnownRemoteModifiedTime: data.lastKnownRemoteModifiedTime.present
          ? data.lastKnownRemoteModifiedTime.value
          : this.lastKnownRemoteModifiedTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpreadsheetMetadataData(')
          ..write('userId: $userId, ')
          ..write('fileId: $fileId, ')
          ..write('worksheetName: $worksheetName, ')
          ..write('lastImportedAt: $lastImportedAt, ')
          ..write('lastKnownRemoteModifiedTime: $lastKnownRemoteModifiedTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    fileId,
    worksheetName,
    lastImportedAt,
    lastKnownRemoteModifiedTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpreadsheetMetadataData &&
          other.userId == this.userId &&
          other.fileId == this.fileId &&
          other.worksheetName == this.worksheetName &&
          other.lastImportedAt == this.lastImportedAt &&
          other.lastKnownRemoteModifiedTime ==
              this.lastKnownRemoteModifiedTime);
}

class SpreadsheetMetadataCompanion
    extends UpdateCompanion<SpreadsheetMetadataData> {
  final Value<String> userId;
  final Value<String> fileId;
  final Value<String> worksheetName;
  final Value<DateTime> lastImportedAt;
  final Value<DateTime?> lastKnownRemoteModifiedTime;
  final Value<int> rowid;
  const SpreadsheetMetadataCompanion({
    this.userId = const Value.absent(),
    this.fileId = const Value.absent(),
    this.worksheetName = const Value.absent(),
    this.lastImportedAt = const Value.absent(),
    this.lastKnownRemoteModifiedTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpreadsheetMetadataCompanion.insert({
    required String userId,
    required String fileId,
    required String worksheetName,
    required DateTime lastImportedAt,
    this.lastKnownRemoteModifiedTime = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       fileId = Value(fileId),
       worksheetName = Value(worksheetName),
       lastImportedAt = Value(lastImportedAt);
  static Insertable<SpreadsheetMetadataData> custom({
    Expression<String>? userId,
    Expression<String>? fileId,
    Expression<String>? worksheetName,
    Expression<DateTime>? lastImportedAt,
    Expression<DateTime>? lastKnownRemoteModifiedTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (fileId != null) 'file_id': fileId,
      if (worksheetName != null) 'worksheet_name': worksheetName,
      if (lastImportedAt != null) 'last_imported_at': lastImportedAt,
      if (lastKnownRemoteModifiedTime != null)
        'last_known_remote_modified_time': lastKnownRemoteModifiedTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpreadsheetMetadataCompanion copyWith({
    Value<String>? userId,
    Value<String>? fileId,
    Value<String>? worksheetName,
    Value<DateTime>? lastImportedAt,
    Value<DateTime?>? lastKnownRemoteModifiedTime,
    Value<int>? rowid,
  }) {
    return SpreadsheetMetadataCompanion(
      userId: userId ?? this.userId,
      fileId: fileId ?? this.fileId,
      worksheetName: worksheetName ?? this.worksheetName,
      lastImportedAt: lastImportedAt ?? this.lastImportedAt,
      lastKnownRemoteModifiedTime:
          lastKnownRemoteModifiedTime ?? this.lastKnownRemoteModifiedTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (fileId.present) {
      map['file_id'] = Variable<String>(fileId.value);
    }
    if (worksheetName.present) {
      map['worksheet_name'] = Variable<String>(worksheetName.value);
    }
    if (lastImportedAt.present) {
      map['last_imported_at'] = Variable<DateTime>(lastImportedAt.value);
    }
    if (lastKnownRemoteModifiedTime.present) {
      map['last_known_remote_modified_time'] = Variable<DateTime>(
        lastKnownRemoteModifiedTime.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpreadsheetMetadataCompanion(')
          ..write('userId: $userId, ')
          ..write('fileId: $fileId, ')
          ..write('worksheetName: $worksheetName, ')
          ..write('lastImportedAt: $lastImportedAt, ')
          ..write('lastKnownRemoteModifiedTime: $lastKnownRemoteModifiedTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LeadsTable leads = $LeadsTable(this);
  late final $SpreadsheetMetadataTable spreadsheetMetadata =
      $SpreadsheetMetadataTable(this);
  late final LeadsDao leadsDao = LeadsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    leads,
    spreadsheetMetadata,
  ];
}

typedef $$LeadsTableCreateCompanionBuilder = LeadsCompanion Function({
  required String id,
  required String userId,
  Value<String?> clientName,
  Value<String?> phoneNumber,
  Value<String?> email,
  Value<String?> eventType,
  Value<DateTime?> eventDate,
  Value<String?> leadSource,
  Value<String?> status,
  Value<DateTime?> lastContactDate,
  Value<DateTime?> nextFollowUpDate,
  Value<DateTime?> reminderDate,
  Value<String?> notes,
  Value<double?> budget,
  Value<String?> assignedPerson,
  required Map<String, dynamic> customFields,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$LeadsTableUpdateCompanionBuilder = LeadsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String?> clientName,
  Value<String?> phoneNumber,
  Value<String?> email,
  Value<String?> eventType,
  Value<DateTime?> eventDate,
  Value<String?> leadSource,
  Value<String?> status,
  Value<DateTime?> lastContactDate,
  Value<DateTime?> nextFollowUpDate,
  Value<DateTime?> reminderDate,
  Value<String?> notes,
  Value<double?> budget,
  Value<String?> assignedPerson,
  Value<Map<String, dynamic>> customFields,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int> rowid,
});

class $$LeadsTableFilterComposer extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leadSource => $composableBuilder(
    column: $table.leadSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastContactDate => $composableBuilder(
    column: $table.lastContactDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextFollowUpDate => $composableBuilder(
    column: $table.nextFollowUpDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignedPerson => $composableBuilder(
    column: $table.assignedPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get customFields => $composableBuilder(
    column: $table.customFields,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeadsTableOrderingComposer
    extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leadSource => $composableBuilder(
    column: $table.leadSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastContactDate => $composableBuilder(
    column: $table.lastContactDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextFollowUpDate => $composableBuilder(
    column: $table.nextFollowUpDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedPerson => $composableBuilder(
    column: $table.assignedPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customFields => $composableBuilder(
    column: $table.customFields,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<DateTime> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<String> get leadSource => $composableBuilder(
    column: $table.leadSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lastContactDate => $composableBuilder(
    column: $table.lastContactDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextFollowUpDate => $composableBuilder(
    column: $table.nextFollowUpDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumn<String> get assignedPerson => $composableBuilder(
    column: $table.assignedPerson,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  get customFields => $composableBuilder(
    column: $table.customFields,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$LeadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeadsTable,
          Lead,
          $$LeadsTableFilterComposer,
          $$LeadsTableOrderingComposer,
          $$LeadsTableAnnotationComposer,
          $$LeadsTableCreateCompanionBuilder,
          $$LeadsTableUpdateCompanionBuilder,
          (Lead, BaseReferences<_$AppDatabase, $LeadsTable, Lead>),
          Lead,
          PrefetchHooks Function()
        > {
  $$LeadsTableTableManager(_$AppDatabase db, $LeadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> clientName = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> eventType = const Value.absent(),
                Value<DateTime?> eventDate = const Value.absent(),
                Value<String?> leadSource = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<DateTime?> lastContactDate = const Value.absent(),
                Value<DateTime?> nextFollowUpDate = const Value.absent(),
                Value<DateTime?> reminderDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> budget = const Value.absent(),
                Value<String?> assignedPerson = const Value.absent(),
                Value<Map<String, dynamic>> customFields = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeadsCompanion(
                id: id,
                userId: userId,
                clientName: clientName,
                phoneNumber: phoneNumber,
                email: email,
                eventType: eventType,
                eventDate: eventDate,
                leadSource: leadSource,
                status: status,
                lastContactDate: lastContactDate,
                nextFollowUpDate: nextFollowUpDate,
                reminderDate: reminderDate,
                notes: notes,
                budget: budget,
                assignedPerson: assignedPerson,
                customFields: customFields,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String?> clientName = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> eventType = const Value.absent(),
                Value<DateTime?> eventDate = const Value.absent(),
                Value<String?> leadSource = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<DateTime?> lastContactDate = const Value.absent(),
                Value<DateTime?> nextFollowUpDate = const Value.absent(),
                Value<DateTime?> reminderDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> budget = const Value.absent(),
                Value<String?> assignedPerson = const Value.absent(),
                required Map<String, dynamic> customFields,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeadsCompanion.insert(
                id: id,
                userId: userId,
                clientName: clientName,
                phoneNumber: phoneNumber,
                email: email,
                eventType: eventType,
                eventDate: eventDate,
                leadSource: leadSource,
                status: status,
                lastContactDate: lastContactDate,
                nextFollowUpDate: nextFollowUpDate,
                reminderDate: reminderDate,
                notes: notes,
                budget: budget,
                assignedPerson: assignedPerson,
                customFields: customFields,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeadsTable,
      Lead,
      $$LeadsTableFilterComposer,
      $$LeadsTableOrderingComposer,
      $$LeadsTableAnnotationComposer,
      $$LeadsTableCreateCompanionBuilder,
      $$LeadsTableUpdateCompanionBuilder,
      (Lead, BaseReferences<_$AppDatabase, $LeadsTable, Lead>),
      Lead,
      PrefetchHooks Function()
    >;
typedef $$SpreadsheetMetadataTableCreateCompanionBuilder =
    SpreadsheetMetadataCompanion Function({
      required String userId,
      required String fileId,
      required String worksheetName,
      required DateTime lastImportedAt,
      Value<DateTime?> lastKnownRemoteModifiedTime,
      Value<int> rowid,
    });
typedef $$SpreadsheetMetadataTableUpdateCompanionBuilder =
    SpreadsheetMetadataCompanion Function({
      Value<String> userId,
      Value<String> fileId,
      Value<String> worksheetName,
      Value<DateTime> lastImportedAt,
      Value<DateTime?> lastKnownRemoteModifiedTime,
      Value<int> rowid,
    });

class $$SpreadsheetMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SpreadsheetMetadataTable> {
  $$SpreadsheetMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worksheetName => $composableBuilder(
    column: $table.worksheetName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastImportedAt => $composableBuilder(
    column: $table.lastImportedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastKnownRemoteModifiedTime => $composableBuilder(
    column: $table.lastKnownRemoteModifiedTime,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpreadsheetMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SpreadsheetMetadataTable> {
  $$SpreadsheetMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worksheetName => $composableBuilder(
    column: $table.worksheetName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastImportedAt => $composableBuilder(
    column: $table.lastImportedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastKnownRemoteModifiedTime =>
      $composableBuilder(
        column: $table.lastKnownRemoteModifiedTime,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$SpreadsheetMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpreadsheetMetadataTable> {
  $$SpreadsheetMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get fileId =>
      $composableBuilder(column: $table.fileId, builder: (column) => column);

  GeneratedColumn<String> get worksheetName => $composableBuilder(
    column: $table.worksheetName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastImportedAt => $composableBuilder(
    column: $table.lastImportedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastKnownRemoteModifiedTime =>
      $composableBuilder(
        column: $table.lastKnownRemoteModifiedTime,
        builder: (column) => column,
      );
}

class $$SpreadsheetMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpreadsheetMetadataTable,
          SpreadsheetMetadataData,
          $$SpreadsheetMetadataTableFilterComposer,
          $$SpreadsheetMetadataTableOrderingComposer,
          $$SpreadsheetMetadataTableAnnotationComposer,
          $$SpreadsheetMetadataTableCreateCompanionBuilder,
          $$SpreadsheetMetadataTableUpdateCompanionBuilder,
          (
            SpreadsheetMetadataData,
            BaseReferences<
              _$AppDatabase,
              $SpreadsheetMetadataTable,
              SpreadsheetMetadataData
            >,
          ),
          SpreadsheetMetadataData,
          PrefetchHooks Function()
        > {
  $$SpreadsheetMetadataTableTableManager(
    _$AppDatabase db,
    $SpreadsheetMetadataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpreadsheetMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpreadsheetMetadataTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SpreadsheetMetadataTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> fileId = const Value.absent(),
                Value<String> worksheetName = const Value.absent(),
                Value<DateTime> lastImportedAt = const Value.absent(),
                Value<DateTime?> lastKnownRemoteModifiedTime =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpreadsheetMetadataCompanion(
                userId: userId,
                fileId: fileId,
                worksheetName: worksheetName,
                lastImportedAt: lastImportedAt,
                lastKnownRemoteModifiedTime: lastKnownRemoteModifiedTime,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String fileId,
                required String worksheetName,
                required DateTime lastImportedAt,
                Value<DateTime?> lastKnownRemoteModifiedTime =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpreadsheetMetadataCompanion.insert(
                userId: userId,
                fileId: fileId,
                worksheetName: worksheetName,
                lastImportedAt: lastImportedAt,
                lastKnownRemoteModifiedTime: lastKnownRemoteModifiedTime,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpreadsheetMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpreadsheetMetadataTable,
      SpreadsheetMetadataData,
      $$SpreadsheetMetadataTableFilterComposer,
      $$SpreadsheetMetadataTableOrderingComposer,
      $$SpreadsheetMetadataTableAnnotationComposer,
      $$SpreadsheetMetadataTableCreateCompanionBuilder,
      $$SpreadsheetMetadataTableUpdateCompanionBuilder,
      (
        SpreadsheetMetadataData,
        BaseReferences<
          _$AppDatabase,
          $SpreadsheetMetadataTable,
          SpreadsheetMetadataData
        >,
      ),
      SpreadsheetMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LeadsTableTableManager get leads =>
      $$LeadsTableTableManager(_db, _db.leads);
  $$SpreadsheetMetadataTableTableManager get spreadsheetMetadata =>
      $$SpreadsheetMetadataTableTableManager(_db, _db.spreadsheetMetadata);
}
