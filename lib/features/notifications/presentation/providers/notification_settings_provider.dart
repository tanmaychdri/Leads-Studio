import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/notifications/domain/notification_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  return NotificationSettingsNotifier();
});

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(const NotificationSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final enabled = prefs.getBool('notif_enabled') ?? true;
    final dailySummaryEnabled = prefs.getBool('notif_daily_summary_enabled') ?? true;
    final overdueAlertsEnabled = prefs.getBool('notif_overdue_alerts_enabled') ?? true;
    
    final reminderHour = prefs.getInt('notif_reminder_hour') ?? 9;
    final reminderMinute = prefs.getInt('notif_reminder_minute') ?? 0;
    
    final summaryHour = prefs.getInt('notif_summary_hour') ?? 8;
    final summaryMinute = prefs.getInt('notif_summary_minute') ?? 0;

    state = NotificationSettings(
      enabled: enabled,
      dailySummaryEnabled: dailySummaryEnabled,
      overdueAlertsEnabled: overdueAlertsEnabled,
      defaultReminderTime: TimeOfDay(hour: reminderHour, minute: reminderMinute),
      dailySummaryTime: TimeOfDay(hour: summaryHour, minute: summaryMinute),
    );
  }

  Future<void> updateSettings(NotificationSettings newSettings) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool('notif_enabled', newSettings.enabled);
    await prefs.setBool('notif_daily_summary_enabled', newSettings.dailySummaryEnabled);
    await prefs.setBool('notif_overdue_alerts_enabled', newSettings.overdueAlertsEnabled);
    
    await prefs.setInt('notif_reminder_hour', newSettings.defaultReminderTime.hour);
    await prefs.setInt('notif_reminder_minute', newSettings.defaultReminderTime.minute);
    
    await prefs.setInt('notif_summary_hour', newSettings.dailySummaryTime.hour);
    await prefs.setInt('notif_summary_minute', newSettings.dailySummaryTime.minute);

    state = newSettings;
  }
}