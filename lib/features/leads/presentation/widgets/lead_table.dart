import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/leads/presentation/widgets/lead_status_badge.dart';

class LeadTable extends StatelessWidget {
  final List<Lead> leads;
  final Function(Lead) onTap;

  const LeadTable({super.key, required this.leads, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (leads.isEmpty) {
      return const Center(child: Text('No leads found.'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: DataTable(
          showCheckboxColumn: false,
          headingRowColor: WidgetStateProperty.all(Colors.grey.withValues(alpha: 0.1)),
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
                DataCell(LeadStatusBadge(status: lead.status ?? 'New')),
                DataCell(Text(lead.nextFollowUpDate != null
                    ? DateFormat('dd MMM yyyy').format(lead.nextFollowUpDate!)
                    : '-')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}