import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/leads/presentation/providers/leads_provider.dart';

final leadDetailsProvider = FutureProvider.family<Lead?, String>((ref, id) async {
  final leadService = ref.watch(leadServiceProvider);
  try {
    return await leadService.getLeadById(id);
  } catch (e) {
    return null;
  }
});