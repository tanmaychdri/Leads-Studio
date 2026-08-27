import 'package:flutter/material.dart';
import 'package:lead_flow/core/widgets/app_page_header.dart';
import 'package:lead_flow/core/widgets/app_empty_state.dart';

class FollowUpsScreen extends StatelessWidget {
  const FollowUpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppPageHeader(title: 'Follow-ups'),
              Expanded(
                child: AppEmptyState(
                  message: 'Your upcoming client follow-ups will appear here.',
                  icon: Icons.calendar_today_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
