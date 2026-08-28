import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:leads_studio/core/widgets/app_empty_state.dart';
import 'package:leads_studio/features/leads/presentation/providers/lead_details_provider.dart';
import 'package:leads_studio/features/leads/presentation/widgets/lead_status_badge.dart';
import 'package:leads_studio/features/leads/presentation/widgets/lead_quick_actions.dart';

class LeadDetailsScreen extends ConsumerWidget {
  final String id;
  const LeadDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadAsync = ref.watch(leadDetailsProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/leads/edit/$id'),
          ),
        ],
      ),
      body: leadAsync.when(
        data: (lead) {
          if (lead == null) {
            return const AppEmptyState(
              
              message: 'This lead may have been deleted.',
              icon: Icons.error_outline,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lead.clientName ?? 'Unknown Client',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    LeadStatusBadge(status: lead.status ?? 'New', fontSize: 14),
                  ],
                ),
                const SizedBox(height: 24),
                LeadQuickActions(lead: lead),
                const SizedBox(height: 24),
                
                _buildSectionHeader(context, 'Contact Information'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(lead.phoneNumber ?? 'No Phone'),
                        subtitle: const Text('Phone Number'),
                      ),
                      if (lead.email != null && lead.email!.isNotEmpty) ...[
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: Text(lead.email!),
                          subtitle: const Text('Email'),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                LeadQuickActions(lead: lead),
                const SizedBox(height: 24),

                _buildSectionHeader(context, 'Event Details'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.event),
                        title: Text(lead.eventType ?? 'Not specified'),
                        subtitle: const Text('Event Type'),
                      ),
                      if (lead.eventDate != null) ...[
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.calendar_month),
                          title: Text(DateFormat('dd MMM yyyy').format(lead.eventDate!)),
                          subtitle: const Text('Event Date'),
                        ),
                      ],
                      if (lead.nextFollowUpDate != null) ...[
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.notification_important, color: Colors.blue),
                          title: Text(
                            DateFormat('dd MMM yyyy').format(lead.nextFollowUpDate!),
                            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text('Next Follow-up'),
                        ),
                      ],
                    ],
                  ),
                ),
                
                if (lead.notes != null && lead.notes!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                LeadQuickActions(lead: lead),
                const SizedBox(height: 24),
                  _buildSectionHeader(context, 'Notes'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(lead.notes!),
                    ),
                  ),
                ],

                if (lead.customFields.isNotEmpty) ...[
                  const SizedBox(height: 24),
                LeadQuickActions(lead: lead),
                const SizedBox(height: 24),
                  _buildSectionHeader(context, 'Custom Fields'),
                  Card(
                    child: Column(
                      children: lead.customFields.entries.map((e) {
                        return ListTile(
                          title: Text(e.value.toString()),
                          subtitle: Text(e.key),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}