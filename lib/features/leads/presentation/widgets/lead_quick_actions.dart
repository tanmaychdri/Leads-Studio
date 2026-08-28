import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/leads/presentation/providers/leads_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class LeadQuickActions extends ConsumerWidget {
  final Lead lead;

  const LeadQuickActions({super.key, required this.lead});

  Future<void> _makePhoneCall(BuildContext context) async {
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
      // Desktop - Copy to clipboard
      await Clipboard.setData(ClipboardData(text: phone));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone number copied to clipboard')));
      }
    }
  }

  Future<void> _softDeleteLead(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Lead?'),
        content: const Text('Are you sure you want to delete this lead? This can be restored later.'),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => ctx.pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final leadService = ref.read(leadServiceProvider);
      await leadService.deleteLead(lead.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lead deleted')));
        context.pop(); // Go back to leads list
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (lead.phoneNumber != null && lead.phoneNumber!.isNotEmpty)
          ElevatedButton.icon(
            onPressed: () => _makePhoneCall(context),
            icon: Icon(isDesktop ? Icons.copy : Icons.call),
            label: Text(isDesktop ? 'Copy Phone' : 'Call Lead'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100, foregroundColor: Colors.green.shade900),
          ),
        ElevatedButton.icon(
          onPressed: () => context.push('/leads/edit/${lead.id}'),
          icon: const Icon(Icons.edit),
          label: const Text('Edit'),
        ),
        ElevatedButton.icon(
          onPressed: () => _softDeleteLead(context, ref),
          icon: const Icon(Icons.delete),
          label: const Text('Delete'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100, foregroundColor: Colors.red.shade900),
        ),
      ],
    );
  }
}