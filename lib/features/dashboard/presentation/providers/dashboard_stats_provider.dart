import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/leads/data/models/lead_status.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/leads/presentation/providers/leads_provider.dart';
import 'package:leads_studio/features/follow_ups/presentation/providers/follow_up_providers.dart';

class DashboardStats {
  final int totalActiveLeads;
  final int overdueFollowUps;
  final int todayFollowUps;
  final int upcomingFollowUps;
  final int needsScheduling;
  final Map<String, int> statusDistribution;

  const DashboardStats({
    this.totalActiveLeads = 0,
    this.overdueFollowUps = 0,
    this.todayFollowUps = 0,
    this.upcomingFollowUps = 0,
    this.needsScheduling = 0,
    this.statusDistribution = const {},
  });
}

final dashboardStatsProvider = Provider<AsyncValue<DashboardStats>>((ref) {
  final user = ref.watch(authProvider).user;
  if (user == null) return const AsyncValue.data(DashboardStats());

  final activeLeadsAsync = ref.watch(activeLeadsProvider);
  final overdueAsync = ref.watch(overdueFollowUpsProvider);
  final todayAsync = ref.watch(todayFollowUpsProvider);
  final upcomingAsync = ref.watch(upcomingFollowUpsProvider);
  final needsSchedulingAsync = ref.watch(needsSchedulingProvider);

  if (activeLeadsAsync.isLoading || overdueAsync.isLoading || todayAsync.isLoading || upcomingAsync.isLoading || needsSchedulingAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (activeLeadsAsync.hasError) return AsyncValue.error(activeLeadsAsync.error!, activeLeadsAsync.stackTrace!);

  final activeLeads = activeLeadsAsync.value ?? [];
  final statusCounts = <String, int>{};
  
  // Initialize map with zeros
  for (var status in LeadStatus.values) {
    statusCounts[status.name] = 0;
  }

  for (final lead in activeLeads) {
    final statusEnum = LeadStatus.fromString(lead.status);
    statusCounts[statusEnum.name] = (statusCounts[statusEnum.name] ?? 0) + 1;
  }

  return AsyncValue.data(
    DashboardStats(
      totalActiveLeads: activeLeads.length,
      overdueFollowUps: overdueAsync.value?.length ?? 0,
      todayFollowUps: todayAsync.value?.length ?? 0,
      upcomingFollowUps: upcomingAsync.value?.length ?? 0,
      needsScheduling: needsSchedulingAsync.value?.length ?? 0,
      statusDistribution: statusCounts,
    ),
  );
});