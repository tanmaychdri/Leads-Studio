import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';
import 'package:leads_studio/app/theme/app_colors.dart';

class LeadTable extends StatelessWidget {
  final List<Lead> leads;
  final Function(Lead) onTap;

  const LeadTable({super.key, required this.leads, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (leads.isEmpty) {
      return const Center(child: Text('No leads found.'));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      padding: EdgeInsets.zero,
      blur: 0,
      opacity: isDark ? 0.3 : 0.6,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 290), // Accounting for sidebar and margins
          child: DataTable(
            showCheckboxColumn: false,
            headingRowColor: WidgetStateProperty.all(isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03)),
            dataRowColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primaryAccent.withValues(alpha: 0.1);
              }
              return null;
            }),
            dividerThickness: 0.5,
            columns: const [
              DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Event', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Follow-up', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: leads.map((lead) {
              return DataRow(
                onSelectChanged: (_) => onTap(lead),
                cells: [
                  DataCell(Text(lead.clientName ?? 'Unknown Client', style: const TextStyle(fontWeight: FontWeight.w600))),
                  DataCell(Text(lead.phoneNumber ?? 'No Phone')),
                  DataCell(Text(lead.eventType ?? '-')),
                  DataCell(_TableStatusBadge(status: lead.status ?? 'New')),
                  DataCell(Text(lead.nextFollowUpDate != null
                      ? DateFormat.yMMMd().format(lead.nextFollowUpDate!)
                      : 'Not Scheduled')),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _TableStatusBadge extends StatelessWidget {
  final String status;

  const _TableStatusBadge({required this.status});

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDark ? color : color.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}