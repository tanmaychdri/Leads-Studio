import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/leads/presentation/widgets/lead_status_badge.dart';

class LeadCard extends StatelessWidget {
  final Lead lead;
  final VoidCallback onTap;

  const LeadCard({super.key, required this.lead, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      (lead.clientName ?? 'Unknown Client'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  LeadStatusBadge(status: lead.status ?? 'New'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(lead.phoneNumber ?? 'No Phone', style: const TextStyle(fontSize: 14)),
                ],
              ),
              if (lead.eventType != null && lead.eventType!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(lead.eventType!, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
              if (lead.nextFollowUpDate != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Follow-up: ${DateFormat('dd MMM yyyy').format(lead.nextFollowUpDate!)}',
                        style: const TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}