import 'package:flutter/material.dart';
import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/core/theme/glass_theme.dart';
import 'package:leads_studio/core/widgets/glass/glass_container.dart';
import 'package:leads_studio/app/theme/app_colors.dart';

class LeadCard extends StatelessWidget {
  final Lead lead;
  final VoidCallback onTap;

  const LeadCard({
    super.key,
    required this.lead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(16.0),
      // Use no blur for list items to maintain 60fps scrolling
      blur: 0,
      opacity: isDark ? 0.4 : 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  lead.clientName ?? 'Unknown Client',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusBadge(status: lead.status ?? 'New'),
            ],
          ),
          const SizedBox(height: 8),
          if (lead.eventType != null && lead.eventType!.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.event, size: 16, color: isDark ? Colors.white54 : Colors.black54),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    lead.eventType!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          if (lead.phoneNumber != null && lead.phoneNumber!.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: isDark ? Colors.white54 : Colors.black54),
                const SizedBox(width: 4),
                Text(
                  lead.phoneNumber!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
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
          color: isDark ? color : color.withValues(alpha: 0.8), // Ensure visibility on light mode
        ),
      ),
    );
  }
}