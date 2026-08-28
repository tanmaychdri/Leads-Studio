import 'package:flutter/material.dart';

enum LeadStatus {
  newLead('New', Colors.blue),
  contacted('Contacted', Colors.orange),
  interested('Interested', Colors.purple),
  followUp('Follow-up', Colors.amber),
  converted('Converted', Colors.green),
  lost('Lost', Colors.red);

  final String displayName;
  final Color color;

  const LeadStatus(this.displayName, this.color);

  static LeadStatus fromString(String? statusStr) {
    if (statusStr == null || statusStr.trim().isEmpty) {
      return LeadStatus.newLead;
    }
    
    final normalized = statusStr.trim().toLowerCase();
    
    return LeadStatus.values.firstWhere(
      (s) => s.displayName.toLowerCase() == normalized || s.name.toLowerCase() == normalized,
      orElse: () => LeadStatus.newLead, // Default if not found
    );
  }
}