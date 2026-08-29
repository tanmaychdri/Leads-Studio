import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/notifications/presentation/providers/notification_settings_provider.dart';
import 'package:leads_studio/features/notifications/data/notification_service.dart';
import 'package:leads_studio/core/widgets/glass/ambient_background.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        const AmbientBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
          ),
          body: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              GlassContainer(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      title: const Text('Enable Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Master switch for all alerts and reminders',
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                      ),
                      value: settings.enabled,
                      onChanged: (value) async {
                        if (value) {
                          await NotificationService().requestPermissions();
                        }
                        notifier.updateSettings(settings.copyWith(enabled: value));
                      },
                    ),
                    if (settings.enabled) ...[
                      Divider(height: 1, color: isDark ? Colors.white12 : Colors.black12),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        title: const Text('Default Reminder Time', style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          settings.defaultReminderTime.format(context),
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                        ),
                        trailing: Icon(Icons.access_time, color: isDark ? Colors.white70 : Colors.black54),
                        onTap: () {
                          _selectTime(context, settings.defaultReminderTime, (time) {
                            notifier.updateSettings(settings.copyWith(defaultReminderTime: time));
                          });
                        },
                      ),
                      Divider(height: 1, color: isDark ? Colors.white12 : Colors.black12),
                      SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        title: const Text('Daily Follow-up Summary', style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          'Get one notification combining all follow-ups for the day',
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                        ),
                        value: settings.dailySummaryEnabled,
                        onChanged: (value) {
                          notifier.updateSettings(settings.copyWith(dailySummaryEnabled: value));
                        },
                      ),
                      if (settings.dailySummaryEnabled)
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          title: const Text('Summary Time', style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            settings.dailySummaryTime.format(context),
                            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                          ),
                          trailing: Icon(Icons.access_time, color: isDark ? Colors.white70 : Colors.black54),
                          onTap: () {
                            _selectTime(context, settings.dailySummaryTime, (time) {
                              notifier.updateSettings(settings.copyWith(dailySummaryTime: time));
                            });
                          },
                        ),
                      Divider(height: 1, color: isDark ? Colors.white12 : Colors.black12),
                      SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        title: const Text('Overdue Alerts', style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          'Notify me if I have missed follow-ups',
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                        ),
                        value: settings.overdueAlertsEnabled,
                        onChanged: (value) {
                          notifier.updateSettings(settings.copyWith(overdueAlertsEnabled: value));
                        },
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}