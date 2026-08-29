import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import 'package:leads_studio/core/widgets/app_empty_state.dart';
import 'package:leads_studio/features/leads/presentation/providers/leads_provider.dart';
import 'package:leads_studio/features/leads/presentation/widgets/lead_card.dart';
import 'package:leads_studio/features/leads/presentation/widgets/lead_table.dart';
import 'package:leads_studio/core/widgets/glass/glass_button.dart';
import 'package:leads_studio/core/widgets/glass/glass_text_field.dart';

class LeadsScreen extends ConsumerWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadsAsync = ref.watch(filteredLeadsProvider);
    final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Leads', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        actions: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GlassButton(
                onPressed: () => context.push('/leads/add'),
                isPrimary: true,
                child: const Row(
                  children: [
                    Icon(Icons.add, size: 20, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Add Lead'),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: isDesktop ? null : Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButton(
          onPressed: () => context.push('/leads/add'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GlassTextField(
              hintText: 'Search by name, phone, or email...',
              prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.black54),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: LeadTable(
                      leads: leads,
                      onTap: (lead) => context.push('/leads/${lead.id}'),
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120, top: 8),
                    itemCount: leads.length,
                    itemBuilder: (context, index) {
                      final lead = leads[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: LeadCard(
                          lead: lead,
                          onTap: () => context.push('/leads/${lead.id}'),
                        ),
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