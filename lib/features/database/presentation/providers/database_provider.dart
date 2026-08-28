import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';

// Provides the singleton database instance
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// Exposes the LeadsDao
final leadsDaoProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.leadsDao;
});

// A stream provider for the active user's leads
final watchLeadsProvider = StreamProvider((ref) {
  final userId = ref.watch(authProvider.select((s) => s.user?.id));
  if (userId == null) return const Stream.empty();

  final dao = ref.watch(leadsDaoProvider);
  return dao.watchLeads(userId);
});

// A stream provider for today's follow-ups
final watchFollowUpsProvider = StreamProvider((ref) {
  final userId = ref.watch(authProvider.select((s) => s.user?.id));
  if (userId == null) return const Stream.empty();

  final dao = ref.watch(leadsDaoProvider);
  return dao.watchFollowUps(userId);
});