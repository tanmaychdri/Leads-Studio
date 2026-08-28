import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/leads/presentation/providers/leads_provider.dart';

final overdueFollowUpsProvider = StreamProvider<List<Lead>>((ref) {
  final user = ref.watch(authProvider).user;
  if (user == null) return const Stream.empty();
  return ref.watch(leadServiceProvider).watchOverdueFollowUps(user.id);
});

final todayFollowUpsProvider = StreamProvider<List<Lead>>((ref) {
  final user = ref.watch(authProvider).user;
  if (user == null) return const Stream.empty();
  return ref.watch(leadServiceProvider).watchTodayFollowUps(user.id);
});

final upcomingFollowUpsProvider = StreamProvider<List<Lead>>((ref) {
  final user = ref.watch(authProvider).user;
  if (user == null) return const Stream.empty();
  return ref.watch(leadServiceProvider).watchUpcomingFollowUps(user.id);
});

final needsSchedulingProvider = StreamProvider<List<Lead>>((ref) {
  final user = ref.watch(authProvider).user;
  if (user == null) return const Stream.empty();
  return ref.watch(leadServiceProvider).watchNeedsScheduling(user.id);
});