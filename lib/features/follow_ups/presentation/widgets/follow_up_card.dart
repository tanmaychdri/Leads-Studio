import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/follow_ups/domain/follow_up_priority.dart';
import 'package:leads_studio/features/follow_ups/presentation/widgets/quick_reschedule_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class FollowUpCard extends StatelessWidget {
  final Lead lead;
  final FollowUpPriority priority;

  const FollowUpCard({
    super.key,
    required this.lead,
    required this.priority,
  });

  Future<void> _contactClient(BuildContext context) async {
    final phone = lead.phoneNumber;
    if (phone == null || phone.isEmpty) return;

    if (Platform.isAndroid || Platform.isIOS) {
      final url = Uri.parse('tel:$phone');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch phone app')));
        }
      }
    } else {
      await Clipboard.setData(ClipboardData(text: phone));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone number copied to clipboard')));
      }
    }
  }

  void _showRescheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => QuickRescheduleDialog(lead: lead),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color stripColor;
    String dateLabel = '';
    
    switch (priority) {
      case FollowUpPriority.critical:
        stripColor = Colors.red;
        if (lead.nextFollowUpDate != null) {
          final diff = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .difference(DateTime(lead.nextFollowUpDate!.year, lead.nextFollowUpDate!.month, lead.nextFollowUpDate!.day))
              .inDays;
          dateLabel = '$diff days overdue';
        }
        break;
      case FollowUpPriority.high:
        stripColor = Colors.orange;
        dateLabel = 'Today';
        break;
      case FollowUpPriority.medium:
        stripColor = Colors.green;
        if (lead.nextFollowUpDate != null) {
          dateLabel = DateFormat('dd MMM yyyy').format(lead.nextFollowUpDate!);
        }
        break;
      case FollowUpPriority.low:
        stripColor = Colors.grey;
        dateLabel = 'No date set';
        break;
      default:
        stripColor = Colors.blueGrey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/leads/${lead.id}'),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: stripColor, width: 4)),
          ),
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
                        lead.clientName ?? 'Unknown Client',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (dateLabel.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: stripColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          dateLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: stripColor,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  lead.eventType ?? 'General Lead',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _contactClient(context),
                        icon: Icon(Platform.isWindows ? Icons.copy : Icons.call, size: 16),
                        label: Text(Platform.isWindows ? 'Copy' : 'Contact'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () => _showRescheduleDialog(context),
                        icon: const Icon(Icons.event, size: 16),
                        label: const Text('Reschedule'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}