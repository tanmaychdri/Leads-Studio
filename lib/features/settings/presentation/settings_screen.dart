import 'package:leads_studio/core/widgets/glass/glass_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_studio/features/drive/presentation/providers/drive_provider.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';
import 'package:leads_studio/core/widgets/glass/glass_button.dart';
import 'package:leads_studio/core/widgets/glass/ambient_background.dart';
import 'package:leads_studio/app/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driveState = ref.watch(driveProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        const AmbientBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'DATABASE CONNECTION'),
              const SizedBox(height: 12),
              
              GlassContainer(
                blur: 0,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!driveState.isConnected) ...[
                      Row(
                        children: [
                          Icon(Icons.cloud_off, color: isDark ? Colors.white54 : Colors.black54, size: 28),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'No lead database connected.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: GlassButton(
                          onPressed: () => context.push('/drive/connect'),
                          isPrimary: true,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_sync, size: 18, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Connect Excel File'),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.table_chart, color: AppColors.success, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driveState.connectedFile!.fileName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Connected to Google Drive',
                                  style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GlassButton(
                              onPressed: driveState.isLoading ? null : () => ref.read(driveProvider.notifier).refreshConnectedFile(),
                              isPrimary: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.refresh, size: 16, color: isDark ? Colors.white : Colors.black87),
                                  const SizedBox(width: 8),
                                  const Text('Refresh', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GlassButton(
                              onPressed: () => context.push('/drive/connect'),
                              isPrimary: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit, size: 16, color: isDark ? Colors.white : Colors.black87),
                                  const SizedBox(width: 8),
                                  const Text('Change', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: GlassButton(
                          onPressed: () => ref.read(driveProvider.notifier).disconnectFile(),
                          isPrimary: false,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.link_off, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Disconnect Database', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: GlassButton(
                          onPressed: () => context.push('/excel/preview'),
                          isPrimary: true,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.analytics, size: 18, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Inspect Spreadsheet Data'),
                            ],
                          ),
                        ),
                      ),
                      if (driveState.isLoading) 
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: LinearProgressIndicator(),
                        ),
                      if (driveState.error != null)
                         Padding(
                           padding: const EdgeInsets.only(top: 16.0),
                           child: Text(driveState.error!, style: const TextStyle(color: Colors.red, fontSize: 14)),
                         ),
                    ]
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader(context, 'PREFERENCES'),
              const SizedBox(height: 12),
              
              GlassContainer(
                blur: 0,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      leading: Icon(Icons.notifications_outlined, color: AppColors.primaryAccent),
                      title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white54 : Colors.black54),
                      onTap: () => context.push('/settings/notifications'),
                    ),
                    Divider(height: 1, color: isDark ? Colors.white12 : Colors.black12),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      leading: Icon(Icons.dark_mode_outlined, color: AppColors.primaryAccent),
                      title: const Text('Theme', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: Text(
                        'System',
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        GlassSnackBar.show(context, 'Theme settings depend on system theme.');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    ),
  ],
);
}

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
      ),
    );
  }
}
