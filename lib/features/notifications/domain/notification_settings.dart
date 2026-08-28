import 'package:flutter/material.dart';

class NotificationSettings {
  final bool enabled;
  final TimeOfDay defaultReminderTime;
  final bool dailySummaryEnabled;
  final TimeOfDay dailySummaryTime;
  final bool overdueAlertsEnabled;

  const NotificationSettings({
    this.enabled = true,
    this.defaultReminderTime = const TimeOfDay(hour: 9, minute: 0),
    this.dailySummaryEnabled = true,
    this.dailySummaryTime = const TimeOfDay(hour: 8, minute: 0),
    this.overdueAlertsEnabled = true,
  });

  NotificationSettings copyWith({
    bool? enabled,
    TimeOfDay? defaultReminderTime,
    bool? dailySummaryEnabled,
    TimeOfDay? dailySummaryTime,
    bool? overdueAlertsEnabled,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      defaultReminderTime: defaultReminderTime ?? this.defaultReminderTime,
      dailySummaryEnabled: dailySummaryEnabled ?? this.dailySummaryEnabled,
      dailySummaryTime: dailySummaryTime ?? this.dailySummaryTime,
      overdueAlertsEnabled: overdueAlertsEnabled ?? this.overdueAlertsEnabled,
    );
  }
}