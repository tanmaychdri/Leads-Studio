import 'package:flutter/material.dart';
import 'package:lead_flow/core/widgets/app_page_header.dart';
import 'package:lead_flow/core/widgets/app_empty_state.dart';

class LeadsScreen extends StatelessWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppPageHeader(
                title: 'Leads',
                action: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add Lead'),
                ),
              ),
              const Expanded(
                child: AppEmptyState(
                  message: 'Your client leads will appear here.',
                  icon: Icons.people_outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
