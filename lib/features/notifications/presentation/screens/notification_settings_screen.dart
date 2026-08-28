import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/notifications/presentation/providers/notification_settings_provider.dart';
import 'package:leads_studio/features/notifications/data/notification_service.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime, Function(TimeOfDay) onSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Master switch for all alerts and reminders'),
            value: settings.enabled,
            onChanged: (value) async {
              if (value) {
                await NotificationService().requestPermissions();
              }
              notifier.updateSettings(settings.copyWith(enabled: value));
            },
          ),
          if (settings.enabled) ...[
            const Divider(),
            ListTile(
              title: const Text('Default Reminder Time'),
              subtitle: Text(settings.defaultReminderTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () {
                _selectTime(context, settings.defaultReminderTime, (time) {
                  notifier.updateSettings(settings.copyWith(defaultReminderTime: time));
                });
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Daily Follow-up Summary'),
              subtitle: const Text('Get one notification combining all follow-ups for the day'),
              value: settings.dailySummaryEnabled,
              onChanged: (value) {
                notifier.updateSettings(settings.copyWith(dailySummaryEnabled: value));
              },
            ),
            if (settings.dailySummaryEnabled)
              ListTile(
                title: const Text('Summary Time'),
                subtitle: Text(settings.dailySummaryTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () {
                  _selectTime(context, settings.dailySummaryTime, (time) {
                    notifier.updateSettings(settings.copyWith(dailySummaryTime: time));
                  });
                },
              ),
            const Divider(),
            SwitchListTile(
              title: const Text('Overdue Alerts'),
              subtitle: const Text('Notify me if I have missed follow-ups'),
              value: settings.overdueAlertsEnabled,
              onChanged: (value) {
                notifier.updateSettings(settings.copyWith(overdueAlertsEnabled: value));
              },
            ),
          ]
        ],
      ),
    );
  }
}