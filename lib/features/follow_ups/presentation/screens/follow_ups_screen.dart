import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/follow_ups/domain/follow_up_priority.dart';
import 'package:leads_studio/features/follow_ups/presentation/providers/follow_up_providers.dart';
import 'package:leads_studio/features/follow_ups/presentation/widgets/follow_up_card.dart';
import 'package:leads_studio/app/theme/app_colors.dart';
import 'dart:io';

class FollowUpsScreen extends ConsumerWidget {
  const FollowUpsScreen({super.key});

  Widget _buildSection(
    BuildContext context, 
    String title, 
    AsyncValue<List<Lead>> asyncLeads, 
    FollowUpPriority priority, 
    IconData icon, 
    Color color
  ) {
    return asyncLeads.when(
      data: (leads) {
        if (leads.isEmpty) return const SizedBox.shrink();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$title (${leads.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: leads.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: FollowUpCard(lead: leads[index], priority: priority),
                );
              },
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Text('Error: $e'),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overdueAsync = ref.watch(overdueFollowUpsProvider);
    final todayAsync = ref.watch(todayFollowUpsProvider);
    final upcomingAsync = ref.watch(upcomingFollowUpsProvider);
    final needsSchedulingAsync = ref.watch(needsSchedulingProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Follow-ups', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Platform.isWindows ? 48.0 : 16.0,
          right: Platform.isWindows ? 48.0 : 16.0,
          bottom: 120.0,
          top: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(context, 'Overdue', overdueAsync, FollowUpPriority.critical, Icons.warning_rounded, AppColors.error),
            _buildSection(context, 'Today', todayAsync, FollowUpPriority.high, Icons.calendar_today, AppColors.warning),
            _buildSection(context, 'Upcoming', upcomingAsync, FollowUpPriority.medium, Icons.next_plan, AppColors.success),
            _buildSection(context, 'Needs Scheduling', needsSchedulingAsync, FollowUpPriority.low, Icons.help_outline, Colors.grey),
            
            // Show empty state if all are empty and loaded
            if (overdueAsync.value?.isEmpty == true && 
                todayAsync.value?.isEmpty == true && 
                upcomingAsync.value?.isEmpty == true && 
                needsSchedulingAsync.value?.isEmpty == true)
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.done_all, size: 64, color: AppColors.success.withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      const Text(
                        'All caught up!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('No pending follow-ups.'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}