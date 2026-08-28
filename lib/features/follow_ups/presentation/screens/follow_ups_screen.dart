import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/follow_ups/domain/follow_up_priority.dart';
import 'package:leads_studio/features/follow_ups/presentation/providers/follow_up_providers.dart';
import 'package:leads_studio/features/follow_ups/presentation/widgets/follow_up_card.dart';
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
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 8),
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
                return FollowUpCard(lead: leads[index], priority: priority);
              },
            ),
            const SizedBox(height: 16),
            const Divider(),
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Follow-ups'),
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: Platform.isWindows ? 48.0 : 16.0,
              vertical: 16.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSection(context, 'Overdue', overdueAsync, FollowUpPriority.critical, Icons.warning_rounded, Colors.red),
                _buildSection(context, 'Today', todayAsync, FollowUpPriority.high, Icons.calendar_today, Colors.orange),
                _buildSection(context, 'Upcoming', upcomingAsync, FollowUpPriority.medium, Icons.next_plan, Colors.green),
                _buildSection(context, 'Needs Scheduling', needsSchedulingAsync, FollowUpPriority.low, Icons.help_outline, Colors.grey),
                
                // Show empty state if all are empty and loaded
                if (overdueAsync.value?.isEmpty == true && 
                    todayAsync.value?.isEmpty == true && 
                    upcomingAsync.value?.isEmpty == true && 
                    needsSchedulingAsync.value?.isEmpty == true)
                  const Padding(
                    padding: EdgeInsets.all(64.0),
                    child: Center(
                      child: Text('No follow-ups needed! You are all caught up.'),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}