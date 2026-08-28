import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/leads/presentation/providers/leads_provider.dart';

class QuickRescheduleDialog extends ConsumerWidget {
  final Lead lead;

  const QuickRescheduleDialog({super.key, required this.lead});

  Future<void> _updateDate(BuildContext context, WidgetRef ref, DateTime newDate) async {
    final leadService = ref.read(leadServiceProvider);
    
    // Show loading indicator
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await leadService.updateLead(lead, nextFollowUpDate: newDate);
      if (context.mounted) {
        context.pop(); // Pop loading
        context.pop(); // Pop dialog
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Follow-up rescheduled')));
      }
    } catch (e) {
      if (context.mounted) {
        context.pop(); // Pop loading
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: lead.nextFollowUpDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && context.mounted) {
      _updateDate(context, ref, picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    return AlertDialog(
      title: Text('Reschedule: ${lead.clientName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.today),
            title: const Text('Tomorrow'),
            onTap: () => _updateDate(context, ref, now.add(const Duration(days: 1))),
          ),
          ListTile(
            leading: const Icon(Icons.next_plan),
            title: const Text('In 3 Days'),
            onTap: () => _updateDate(context, ref, now.add(const Duration(days: 3))),
          ),
          ListTile(
            leading: const Icon(Icons.view_week),
            title: const Text('Next Week'),
            onTap: () => _updateDate(context, ref, now.add(const Duration(days: 7))),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Pick Custom Date...'),
            onTap: () => _pickDate(context, ref),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}