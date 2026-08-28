import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_studio/core/widgets/app_empty_state.dart';
import 'package:leads_studio/features/leads/presentation/providers/leads_provider.dart';
import 'package:leads_studio/features/leads/presentation/widgets/lead_card.dart';
import 'package:leads_studio/features/leads/presentation/widgets/lead_table.dart';
import 'dart:io';

class LeadsScreen extends ConsumerWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadsAsync = ref.watch(filteredLeadsProvider);
    final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FilledButton.icon(
                onPressed: () => context.push('/leads/add'),
                icon: const Icon(Icons.add),
                label: const Text('Add Lead'),
              ),
            ),
        ],
      ),
      floatingActionButton: isDesktop ? null : FloatingActionButton(
        onPressed: () => context.push('/leads/add'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, phone, or email...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) => ref.read(leadSearchQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: leadsAsync.when(
              data: (leads) {
                if (leads.isEmpty) {
                  return const AppEmptyState(
                    
                    message: 'Your client leads will appear here.',
                    icon: Icons.people_outline,
                  );
                }
                
                if (isDesktop) {
                  return LeadTable(
                    leads: leads,
                    onTap: (lead) => context.push('/leads/${lead.id}'),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: leads.length,
                    itemBuilder: (context, index) {
                      final lead = leads[index];
                      return LeadCard(
                        lead: lead,
                        onTap: () => context.push('/leads/${lead.id}'),
                      );
                    },
                  );
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}