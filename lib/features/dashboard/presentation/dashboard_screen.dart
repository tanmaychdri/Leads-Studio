import 'package:flutter/material.dart';
import 'package:lead_flow/core/widgets/app_page_header.dart';
import 'package:lead_flow/core/widgets/app_card.dart';
import 'package:lead_flow/core/widgets/app_empty_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning 👋',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              const AppPageHeader(title: 'Dashboard'),
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      child: Column(
                        children: [
                          const Icon(Icons.people, size: 32),
                          const SizedBox(height: 8),
                          Text('Total Leads', style: Theme.of(context).textTheme.labelLarge),
                          Text('142', style: Theme.of(context).textTheme.headlineMedium),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppCard(
                      child: Column(
                        children: [
                          const Icon(Icons.calendar_today, size: 32),
                          const SizedBox(height: 8),
                          Text('Follow-ups Today', style: Theme.of(context).textTheme.labelLarge),
                          Text('8', style: Theme.of(context).textTheme.headlineMedium),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppCard(
                      child: Column(
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 32, color: Theme.of(context).colorScheme.error),
                          const SizedBox(height: 8),
                          Text('Overdue Leads', style: Theme.of(context).textTheme.labelLarge),
                          Text('3', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.error)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text('Today\'s Follow-ups', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              const Expanded(
                child: AppEmptyState(
                  message: 'No data yet',
                  icon: Icons.inbox_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
