import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_studio/features/drive/presentation/providers/drive_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driveState = ref.watch(driveProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lead Database', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              )),
              const SizedBox(height: 16),
              
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!driveState.isConnected) ...[
                        const Row(
                          children: [
                            Icon(Icons.cloud_off, color: Colors.grey),
                            SizedBox(width: 16),
                            Expanded(child: Text('No lead database connected.')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => context.push('/drive/connect'),
                            icon: const Icon(Icons.cloud_sync),
                            label: const Text('Connect Excel File'),
                          ),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            const Icon(Icons.table_chart, color: Colors.green),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(driveState.connectedFile!.fileName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const Text('Connected to Google Drive', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: driveState.isLoading ? null : () => ref.read(driveProvider.notifier).refreshConnectedFile(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refresh'),
                            ),
                            TextButton.icon(
                              onPressed: () => context.push('/drive/connect'),
                              icon: const Icon(Icons.edit),
                              label: const Text('Change File'),
                            ),
                            TextButton.icon(
                              onPressed: () => ref.read(driveProvider.notifier).disconnectFile(),
                              icon: const Icon(Icons.link_off, color: Colors.red),
                              label: const Text('Disconnect', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => context.push('/excel/preview'),
                            icon: const Icon(Icons.analytics),
                            label: const Text('Inspect Spreadsheet Data'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        if (driveState.isLoading) const LinearProgressIndicator(),
                        if (driveState.error != null)
                           Padding(
                             padding: const EdgeInsets.only(top: 8.0),
                             child: Text(driveState.error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                           ),
                      ]
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              Text('Preferences', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              )),
              const SizedBox(height: 16),
              
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: const Text('Notifications'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.dark_mode_outlined),
                      title: const Text('Theme'),
                      trailing: const Text('Light'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
