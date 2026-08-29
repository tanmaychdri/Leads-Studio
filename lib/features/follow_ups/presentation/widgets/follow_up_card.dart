import 'package:leads_studio/core/widgets/glass/glass_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/follow_ups/domain/follow_up_priority.dart';
import 'package:leads_studio/features/follow_ups/presentation/widgets/quick_reschedule_dialog.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';
import 'package:leads_studio/core/widgets/glass/glass_button.dart';
import 'package:leads_studio/app/theme/app_colors.dart';
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
          GlassSnackBar.show(context, 'Could not launch phone app', isError: true);
        }
      }
    } else {
      await Clipboard.setData(ClipboardData(text: phone));
      if (context.mounted) {
        GlassSnackBar.show(context, 'Phone number copied to clipboard', isSuccess: true);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      onTap: () => context.push('/leads/${lead.id}'),
      padding: const EdgeInsets.all(16.0),
      blur: 0,
      opacity: isDark ? 0.3 : 0.6,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lead.clientName ?? 'Unknown Client',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                if (lead.phoneNumber != null && lead.phoneNumber!.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: isDark ? Colors.white54 : Colors.black54),
                      const SizedBox(width: 4),
                      Text(
                        lead.phoneNumber!,
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 14,
                      color: priority == FollowUpPriority.critical ? AppColors.error : AppColors.primaryAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      lead.nextFollowUpDate != null
                          ? DateFormat('dd MMM yyyy').format(lead.nextFollowUpDate!)
                          : 'Not Scheduled',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: priority == FollowUpPriority.critical ? AppColors.error : AppColors.primaryAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (lead.phoneNumber != null && lead.phoneNumber!.isNotEmpty)
                GlassButton(
                  onPressed: () => _contactClient(context),
                  isPrimary: true,
                  opacity: 0.9,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Platform.isWindows ? Icons.copy : Icons.call, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(Platform.isWindows ? 'Copy' : 'Call', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                )
              else
                const SizedBox(height: 36),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _showRescheduleDialog(context),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    'Reschedule',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white54 : Colors.black54,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}