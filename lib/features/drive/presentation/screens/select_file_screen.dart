import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_studio/features/drive/presentation/providers/drive_provider.dart';

class SelectFileScreen extends ConsumerWidget {
  const SelectFileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driveState = ref.watch(driveProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Lead Database'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh file list',
            onPressed: driveState.isLoading 
              ? null 
              : () => ref.read(driveProvider.notifier).connectDriveAndFetchFiles(),
          ),
        ],
      ),
      body: SafeArea(
        child: driveState.isLoading && driveState.availableFiles.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : driveState.error != null && driveState.availableFiles.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(driveState.error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => ref.read(driveProvider.notifier).connectDriveAndFetchFiles(),
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  )
                : driveState.availableFiles.isEmpty
                    ? const Center(
                        child: Text(
                          'No Excel (.xlsx) files found in your Google Drive.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: driveState.availableFiles.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final file = driveState.availableFiles[index];
                          
                          // Format size
                          String sizeStr = '';
                          if (file.size != null) {
                            final kb = file.size! / 1024;
                            sizeStr = kb > 1024 ? '${(kb / 1024).toStringAsFixed(1)} MB' : '${kb.toStringAsFixed(0)} KB';
                          }

                          // Format date
                          String dateStr = '';
                          if (file.modifiedTime != null) {
                            dateStr = '${file.modifiedTime!.year}-${file.modifiedTime!.month.toString().padLeft(2, '0')}-${file.modifiedTime!.day.toString().padLeft(2, '0')}';
                          }

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(Icons.table_chart, color: Colors.white),
                            ),
                            title: Text(file.fileName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Modified: $dateStr • Size: $sizeStr'),
                            trailing: driveState.isLoading 
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                              : FilledButton(
                                  onPressed: () async {
                                    await ref.read(driveProvider.notifier).selectAndDownloadFile(file);
                                    if (context.mounted && ref.read(driveProvider).error == null) {
                                      // Pop back to settings on success
                                      context.pop();
                                      context.pop();
                                    } else if (context.mounted) {
                                      // Show error if download failed
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(ref.read(driveProvider).error ?? 'Failed to download')),
                                      );
                                    }
                                  },
                                  child: const Text('Select'),
                                ),
                          );
                        },
                      ),
      ),
    );
  }
}
