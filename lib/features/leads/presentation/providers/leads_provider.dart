import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/database/presentation/providers/database_provider.dart';
import 'package:leads_studio/features/leads/data/services/lead_service.dart';

// Provides the LeadService singleton
final leadServiceProvider = Provider<LeadService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LeadService(db.leadsDao);
});

// A stream of ALL active leads for the current user
final activeLeadsProvider = StreamProvider<List<Lead>>((ref) {
  final user = ref.watch(authProvider).user;
  if (user == null) {
    return const Stream.empty();
  }
  final leadService = ref.watch(leadServiceProvider);
  return leadService.watchLeads(user.id);
});

// StateProvider for the search query
final leadSearchQueryProvider = StateProvider<String>((ref) => '');

// A derived provider that filters active leads by the search query
final filteredLeadsProvider = Provider<AsyncValue<List<Lead>>>((ref) {
  final leadsAsync = ref.watch(activeLeadsProvider);
  final searchQuery = ref.watch(leadSearchQueryProvider).toLowerCase().trim();

  return leadsAsync.whenData((leads) {
    if (searchQuery.isEmpty) return leads;
    
    return leads.where((lead) {
      final matchName = (lead.clientName ?? '').toLowerCase().contains(searchQuery);
      final matchPhone = (lead.phoneNumber ?? '').toLowerCase().contains(searchQuery);
      final matchEmail = (lead.email ?? '').toLowerCase().contains(searchQuery);
      
      return matchName || matchPhone || matchEmail;
    }).toList();
  });
});