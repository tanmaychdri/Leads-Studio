import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/core/sync/sync_engine.dart';
import 'package:leads_studio/core/sync/sync_models.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';
import 'package:leads_studio/core/widgets/glass/glass_button.dart';
import 'package:leads_studio/app/theme/app_colors.dart';

class SyncStatusWidget extends ConsumerWidget {
  const SyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncStateProvider);
    final engine = ref.read(syncEngineProvider);

    return GlassContainer(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildStatusIcon(syncState),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(syncState),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (syncState.errorMessage != null)
                  Text(
                    syncState.errorMessage!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                else if (syncState.lastSyncTime != null)
                  Text(
                    'Last synced: ${_formatTime(syncState.lastSyncTime!)}',
                    style: TextStyle(
                      fontSize: 12, 
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
          if (syncState.status == SyncStatus.syncing)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryAccent),
            )
          else if (syncState.status == SyncStatus.conflict)
            GlassButton(
              onPressed: () => _showConflictDialog(context, ref, syncState.activeConflicts!),
              isPrimary: true,
              child: const Text('Resolve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          else
            GlassButton(
              onPressed: () => engine.triggerSync(),
              isPrimary: syncState.status == SyncStatus.failed,
              child: const Icon(Icons.sync),
            ),
        ],
      ),
    );
  }

  void _showConflictDialog(BuildContext context, WidgetRef ref, List<SyncConflict> conflicts) {
    if (conflicts.isEmpty) return;
    
    final conflict = conflicts.first; // Resolve one by one for MVP
    final engine = ref.read(syncEngineProvider);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Conflict Resolution',
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(24),
              child: GlassContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
                        SizedBox(width: 12),
                        Text('Sync Conflict', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The lead "${conflict.clientName}" was modified locally and in Google Drive since the last sync.',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: GlassButton(
                        onPressed: () {
                          engine.resolveConflict(conflict.leadId, true);
                          Navigator.pop(ctx);
                        },
                        isPrimary: true,
                        child: const Text('Keep Local Version (Overwrite Drive)', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: GlassButton(
                        onPressed: () {
                          engine.resolveConflict(conflict.leadId, false);
                          Navigator.pop(ctx);
                        },
                        child: const Text('Keep Drive Version (Overwrite Local)', style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(SyncState state) {
    switch (state.status) {
      case SyncStatus.idle:
      case SyncStatus.success:
        return const Icon(Icons.cloud_done, color: AppColors.primaryAccent, size: 28);
      case SyncStatus.syncing:
        return const Icon(Icons.cloud_sync, color: Colors.white, size: 28);
      case SyncStatus.failed:
        return const Icon(Icons.cloud_off, color: Colors.redAccent, size: 28);
      case SyncStatus.conflict:
        return const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 28);
    }
  }

  String _getStatusText(SyncState state) {
    switch (state.status) {
      case SyncStatus.idle:
      case SyncStatus.success:
        return 'All changes synced';
      case SyncStatus.syncing:
        return 'Syncing with Google Drive...';
      case SyncStatus.failed:
        return 'Sync failed';
      case SyncStatus.conflict:
        return 'Conflicts require attention';
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    final min = time.minute.toString().padLeft(2, '0');
    return '$hour:$min $amPm';
  }
}
