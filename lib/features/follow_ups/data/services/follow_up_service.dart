import 'package:leads_studio/features/database/data/app_database.dart';
import 'package:leads_studio/features/follow_ups/domain/follow_up_priority.dart';
import 'package:leads_studio/features/leads/data/models/lead_status.dart';

class FollowUpService {
  /// Strips time components and returns the logical calendar date
  static DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Determines the priority of a lead for follow-up actions
  static FollowUpPriority getPriority(Lead lead) {
    // 1. Check if inactive
    if (_isInactiveStatus(lead.status)) {
      return FollowUpPriority.none;
    }

    // 2. Check Needs Scheduling (no follow-up date)
    if (lead.nextFollowUpDate == null) {
      return FollowUpPriority.low; // Needs Scheduling
    }

    final today = normalizeDate(DateTime.now());
    final followUpDate = normalizeDate(lead.nextFollowUpDate!);

    // 3. Overdue (Critical)
    if (followUpDate.isBefore(today)) {
      return FollowUpPriority.critical;
    }

    // 4. Today (High)
    if (followUpDate.isAtSameMomentAs(today)) {
      return FollowUpPriority.high;
    }

    // 5. Upcoming (Medium)
    return FollowUpPriority.medium;
  }

  /// Helper to determine if a status string represents an inactive lead
  static bool _isInactiveStatus(String? statusStr) {
    final status = LeadStatus.fromString(statusStr);
    return status == LeadStatus.converted || status == LeadStatus.lost;
  }

  /// Helper to classify exactly which "Upcoming" bucket it falls into
  static String getUpcomingCategory(DateTime followUpDate) {
    final today = normalizeDate(DateTime.now());
    final date = normalizeDate(followUpDate);
    
    final difference = date.difference(today).inDays;
    
    if (difference == 1) {
      return 'Tomorrow';
    } else if (difference <= 7) {
      return 'Next 7 Days';
    } else {
      return 'Later';
    }
  }
}