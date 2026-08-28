import 'package:flutter/material.dart';
import 'package:leads_studio/features/leads/data/models/lead_status.dart';

class LeadStatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;
  
  const LeadStatusBadge({super.key, required this.status, this.fontSize = 12.0});

  @override
  Widget build(BuildContext context) {
    final leadStatus = LeadStatus.fromString(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: leadStatus.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: leadStatus.color.withValues(alpha: 0.3)),
      ),
      child: Text(
        leadStatus.displayName,
        style: TextStyle(
          color: leadStatus.color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}