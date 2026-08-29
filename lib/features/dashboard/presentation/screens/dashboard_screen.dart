import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/dashboard/presentation/providers/dashboard_stats_provider.dart';
import 'package:leads_studio/features/dashboard/presentation/widgets/dashboard_stat_card.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';
import 'package:leads_studio/core/theme/glass_theme.dart';
import 'package:leads_studio/app/theme/app_colors.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final user = ref.watch(authProvider).user;
    final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: statsAsync.when(
        data: (stats) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24.0, 
              right: 24.0, 
              top: isDesktop ? 48.0 : 16.0, 
              bottom: 120.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getGreeting()}, ${user?.displayName?.split(' ').first ?? 'User'}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here is your LeadFlow overview.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
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
                      childAspectRatio: 1.5,
                      children: [
                        DashboardStatCard(
                          title: 'Active Leads',
                          value: stats.totalActiveLeads.toString(),
                          icon: Icons.people_outline,
                          color: AppColors.primaryAccent,
                        ),
                        DashboardStatCard(
                          title: 'Overdue',
                          value: stats.overdueFollowUps.toString(),
                          icon: Icons.warning_amber_rounded,
                          color: AppColors.error,
                        ),
                        DashboardStatCard(
                          title: 'Today',
                          value: stats.todayFollowUps.toString(),
                          icon: Icons.calendar_today,
                          color: AppColors.warning,
                        ),
                        DashboardStatCard(
                          title: 'Upcoming',
                          value: stats.upcomingFollowUps.toString(),
                          icon: Icons.next_plan,
                          color: AppColors.success,
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
                SizedBox(
                  width: double.infinity,
                  child: GlassContainer(
                    padding: const EdgeInsets.all(24.0),
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: stats.statusDistribution.entries.map((entry) {
                      return SizedBox(
                        width: 140,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
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
                
                // QUICK ACTIONS
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GlassContainer(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        onTap: () => context.push('/leads/new'),
                        child: const Column(
                          children: [
                            Icon(Icons.person_add_alt_1, size: 32, color: AppColors.primaryAccent),
                            SizedBox(height: 12),
                            Text('Add Lead', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GlassContainer(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        onTap: () => context.push('/follow_ups'),
                        child: const Column(
                          children: [
                            Icon(Icons.calendar_month, size: 32, color: AppColors.secondaryAccent),
                            SizedBox(height: 12),
                            Text('Follow-ups', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}