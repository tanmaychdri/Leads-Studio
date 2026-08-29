import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:leads_studio/core/widgets/app_empty_state.dart';
import 'package:leads_studio/features/leads/presentation/providers/lead_details_provider.dart';
import 'package:leads_studio/features/leads/presentation/widgets/lead_quick_actions.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';
import 'package:leads_studio/core/widgets/glass/glass_button.dart';
import 'package:leads_studio/app/theme/app_colors.dart';

class LeadDetailsScreen extends ConsumerWidget {
  final String id;
  const LeadDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadAsync = ref.watch(leadDetailsProvider(id));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Lead Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GlassButton(
              isPrimary: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onPressed: () => context.push('/leads/edit/$id'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
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
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 120.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PROFILE SECTION
                GlassContainer(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead.clientName ?? 'Unknown Client',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                _StatusBadge(status: lead.status ?? 'New'),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: AppColors.primaryAccent.withValues(alpha: 0.2),
                            child: const Icon(Icons.person, size: 36, color: AppColors.primaryAccent),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 20, color: AppColors.primaryAccent),
                          const SizedBox(width: 12),
                          Text(lead.phoneNumber ?? 'No Phone', style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      if (lead.email != null && lead.email!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 20, color: AppColors.primaryAccent),
                            const SizedBox(width: 12),
                            Text(lead.email!, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                LeadQuickActions(lead: lead),
                const SizedBox(height: 32),

                // EVENT DETAILS
                _buildSectionHeader(context, 'EVENT INFORMATION'),
                const SizedBox(height: 12),
                GlassContainer(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: Icons.event,
                        title: 'Event Type',
                        value: lead.eventType ?? 'Not specified',
                      ),
                      if (lead.eventDate != null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(color: Colors.white24),
                        ),
                        _DetailRow(
                          icon: Icons.calendar_month,
                          title: 'Event Date',
                          value: DateFormat('dd MMM yyyy').format(lead.eventDate!),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // FOLLOW UP
                _buildSectionHeader(context, 'NEXT FOLLOW-UP'),
                const SizedBox(height: 12),
                GlassContainer(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      const Icon(Icons.notification_important, color: AppColors.warning, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lead.nextFollowUpDate != null 
                                  ? DateFormat('EEEE, dd MMM yyyy').format(lead.nextFollowUpDate!)
                                  : 'Not Scheduled',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            if (lead.reminderDate != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Reminder: ${DateFormat('dd MMM yyyy').format(lead.reminderDate!)}',
                                style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (lead.notes != null && lead.notes!.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _buildSectionHeader(context, 'NOTES'),
                  const SizedBox(height: 12),
                  GlassContainer(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      lead.notes!,
                      style: const TextStyle(height: 1.5),
                    ),
                  ),
                ],

                if (lead.customFields.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _buildSectionHeader(context, 'CUSTOM FIELDS'),
                  const SizedBox(height: 12),
                  GlassContainer(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: lead.customFields.entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _DetailRow(
                            icon: Icons.label_outline,
                            title: e.key,
                            value: e.value.toString(),
                          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: isDark ? Colors.white54 : Colors.black54),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color _getStatusColor() {
    final s = status.toLowerCase();
    if (s == 'new') return AppColors.info;
    if (s == 'interested') return AppColors.primaryAccent;
    if (s == 'converted') return AppColors.success;
    if (s == 'lost') return AppColors.error;
    if (s == 'follow-up' || s == 'follow up') return AppColors.warning;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? color : color.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}