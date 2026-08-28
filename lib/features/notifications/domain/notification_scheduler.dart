import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/notifications/data/notification_service.dart';
import 'package:leads_studio/features/notifications/domain/notification_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ReminderScheduler {
  final NotificationService _notificationService = NotificationService();

  // Deterministic ID generation based on lead ID string
  int _generateId(String uuid, String type) {
    // Basic hash of uuid + type
    return (uuid + type).hashCode;
  }

  Future<NotificationSettings> _getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationSettings(
      enabled: prefs.getBool('notif_enabled') ?? true,
      dailySummaryEnabled: prefs.getBool('notif_daily_summary_enabled') ?? true,
      overdueAlertsEnabled: prefs.getBool('notif_overdue_alerts_enabled') ?? true,
      defaultReminderTime: TimeOfDay(
        hour: prefs.getInt('notif_reminder_hour') ?? 9,
        minute: prefs.getInt('notif_reminder_minute') ?? 0,
      ),
      dailySummaryTime: TimeOfDay(
        hour: prefs.getInt('notif_summary_hour') ?? 8,
        minute: prefs.getInt('notif_summary_minute') ?? 0,
      ),
    );
  }

  bool _isInactiveStatus(String? status) {
    final lower = status?.toLowerCase() ?? '';
    return lower == 'converted' || lower == 'lost';
  }

  Future<void> scheduleLeadNotifications(Lead lead) async {
    final settings = await _getSettings();
    if (!settings.enabled) return;

    // 1. Check if lead is active
    if (_isInactiveStatus(lead.status)) {
      await cancelLeadNotifications(lead.id);
      return;
    }

    // 2. Schedule Follow-up Notification (nextFollowUpDate + defaultReminderTime)
    if (lead.nextFollowUpDate != null) {
      final followUpId = _generateId(lead.id, 'followup');
      
      // Merge date with default time
      final d = lead.nextFollowUpDate!;
      final scheduledTime = DateTime(
        d.year, d.month, d.day,
        settings.defaultReminderTime.hour,
        settings.defaultReminderTime.minute,
      );

      await _notificationService.scheduleReminder(
        id: followUpId,
        title: 'Follow-up Today',
        body: 'Follow up with ${lead.clientName ?? 'Client'}.',
        scheduledDate: scheduledTime,
        payload: 'lead_followup:${lead.id}',
      );
    } else {
      await _notificationService.cancelReminder(_generateId(lead.id, 'followup'));
    }

    // 3. Schedule Reminder Notification (reminderDate + defaultReminderTime)
    if (lead.reminderDate != null) {
      final reminderId = _generateId(lead.id, 'reminder');
      
      final d = lead.reminderDate!;
      final scheduledTime = DateTime(
        d.year, d.month, d.day,
        settings.defaultReminderTime.hour,
        settings.defaultReminderTime.minute,
      );

      await _notificationService.scheduleReminder(
        id: reminderId,
        title: 'LeadFlow Reminder',
        body: 'Upcoming action for ${lead.clientName ?? 'Client'}.',
        scheduledDate: scheduledTime,
        payload: 'lead_reminder:${lead.id}',
      );
    } else {
      await _notificationService.cancelReminder(_generateId(lead.id, 'reminder'));
    }
  }

  Future<void> cancelLeadNotifications(String leadId) async {
    await _notificationService.cancelReminder(_generateId(leadId, 'followup'));
    await _notificationService.cancelReminder(_generateId(leadId, 'reminder'));
  }

  Future<void> rescheduleLeadNotifications(Lead lead) async {
    // Simply reschedules by cancelling implicit old ones because the ID is deterministic
    // The zonedSchedule method automatically overwrites if the ID is the same
    await scheduleLeadNotifications(lead);
  }

  Future<void> reconcileDailySummaries(List<Lead> allLeads) async {
    final settings = await _getSettings();
    if (!settings.enabled) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    int todayCount = 0;
    int overdueCount = 0;

    for (final lead in allLeads) {
      if (_isInactiveStatus(lead.status) || lead.nextFollowUpDate == null) continue;
      
      final d = lead.nextFollowUpDate!;
      final leadDate = DateTime(d.year, d.month, d.day);
      
      if (leadDate.isAtSameMomentAs(today)) todayCount++;
      if (leadDate.isBefore(today)) overdueCount++;
    }

    // Determine when to schedule the summary (today or tomorrow)
    DateTime summaryTime = DateTime(
      now.year, now.month, now.day,
      settings.dailySummaryTime.hour,
      settings.dailySummaryTime.minute,
    );
    
    // If the summary time has already passed today, we don't schedule one for today.
    // Instead we could schedule one for tomorrow, but since it depends on tomorrow's leads,
    // we would need to calculate tomorrowCount. For MVP, we just schedule for tomorrow based on what we know.
    if (summaryTime.isBefore(now)) {
      summaryTime = summaryTime.add(const Duration(days: 1));
      // Re-calculate for tomorrow
      final tomorrow = today.add(const Duration(days: 1));
      todayCount = 0;
      for (final lead in allLeads) {
        if (_isInactiveStatus(lead.status) || lead.nextFollowUpDate == null) continue;
        final d = lead.nextFollowUpDate!;
        final leadDate = DateTime(d.year, d.month, d.day);
        if (leadDate.isAtSameMomentAs(tomorrow)) todayCount++;
      }
    }

    final int summaryId = 9999991;
    final int overdueId = 9999992;

    if (settings.dailySummaryEnabled && todayCount > 0) {
      await _notificationService.scheduleReminder(
        id: summaryId,
        title: 'LeadFlow — Today\'s Follow-ups',
        body: 'You have $todayCount clients to contact today.',
        scheduledDate: summaryTime,
        payload: 'daily_summary',
      );
    } else {
      await _notificationService.cancelReminder(summaryId);
    }

    if (settings.overdueAlertsEnabled && overdueCount > 0) {
      await _notificationService.scheduleReminder(
        id: overdueId,
        title: 'LeadFlow — Overdue Follow-ups',
        body: 'You have $overdueCount overdue client follow-ups that need attention.',
        scheduledDate: summaryTime.add(const Duration(minutes: 5)), // 5 mins after summary
        payload: 'overdue_summary',
      );
    } else {
      await _notificationService.cancelReminder(overdueId);
    }
  }
}