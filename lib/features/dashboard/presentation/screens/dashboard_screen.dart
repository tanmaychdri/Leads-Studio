import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/dashboard/presentation/providers/dashboard_stats_provider.dart';
import 'package:leads_studio/features/dashboard/presentation/widgets/dashboard_stat_card.dart';
import 'dart:io';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final user = ref.watch(authProvider).user;
    final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

    return Scaffold(
      body: statsAsync.when(
        data: (stats) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning, ${user?.displayName?.split(' ').first ?? 'User'} ðŸ‘‹',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here is your lead overview.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 32),

                // SUMMARY CARDS
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = isDesktop ? 4 : (constraints.maxWidth > 600 ? 4 : 2);
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: isDesktop ? 1.5 : 1.2,
                      children: [
                        DashboardStatCard(
                          title: 'Active Leads',
                          value: stats.totalActiveLeads.toString(),
                          icon: Icons.people,
                          color: Colors.blue,
                        ),
                        DashboardStatCard(
                          title: 'Overdue',
                          value: stats.overdueFollowUps.toString(),
                          icon: Icons.warning_amber_rounded,
                          color: Colors.red,
                        ),
                        DashboardStatCard(
                          title: 'Today',
                          value: stats.todayFollowUps.toString(),
                          icon: Icons.calendar_today,
                          color: Colors.orange,
                        ),
                        DashboardStatCard(
                          title: 'Upcoming',
                          value: stats.upcomingFollowUps.toString(),
                          icon: Icons.next_plan,
                          color: Colors.green,
                        ),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 32),

                // STATUS DISTRIBUTION
                Text(
                  'Lead Status Distribution',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: stats.statusDistribution.entries.map((entry) {
                        return SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.value.toString(),
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // QUICK ACTION / CTA
                Center(
                  child: FilledButton.icon(
                    onPressed: () => context.go('/follow-ups'),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Go to Follow-ups'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}