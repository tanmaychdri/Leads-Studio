import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_studio/features/drive/presentation/providers/drive_provider.dart';

class ConnectDriveScreen extends ConsumerWidget {
  const ConnectDriveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driveState = ref.watch(driveProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Drive'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_sync, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                'Connect Your Lead Database',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Connect Google Drive and select the Excel file you use to manage your client leads.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              if (driveState.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    driveState.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: driveState.isLoading
                      ? null
                      : () async {
                          final success = await ref.read(driveProvider.notifier).connectDriveAndFetchFiles();
                          if (success && context.mounted) {
                            context.push('/drive/select');
                          }
                        },
                  icon: driveState.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.add_to_drive),
                  label: const Text('Connect Google Drive', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
