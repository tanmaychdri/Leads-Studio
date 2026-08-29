import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/leads/presentation/providers/leads_provider.dart';
import 'package:leads_studio/core/widgets/glass/glass_button.dart';
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GlassButton(
                onPressed: () => _makePhoneCall(context),
                isPrimary: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isDesktop ? Icons.copy : Icons.call, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(isDesktop ? 'Copy' : 'Call'),
                  ],
                ),
              ),
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GlassButton(
              onPressed: () => _softDeleteLead(context, ref),
              isPrimary: false,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}