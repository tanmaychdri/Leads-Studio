import 'package:flutter/material.dart';
import 'package:leads_studio/core/widgets/app_page_header.dart';
import 'package:leads_studio/core/widgets/app_card.dart';
import 'package:leads_studio/core/widgets/app_empty_state.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppPageHeader(title: 'Dashboard').animate().fade(duration: 400.ms).slideX(begin: -0.1, end: 0),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.people_alt_outlined, size: 28, color: Theme.of(context).colorScheme.primary),
                          ),
                          const SizedBox(height: 16),
                          Text('Total Leads', style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: 4),
                          Text('142', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ).animate().fade(delay: 100.ms).slideY(begin: 0.1, end: 0),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.calendar_month_outlined, size: 28, color: Colors.blue),
                          ),
                          const SizedBox(height: 16),
                          Text('Follow-ups', style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: 4),
                          Text('8', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.warning_amber_rounded, size: 28, color: Theme.of(context).colorScheme.error),
                          ),
                          const SizedBox(height: 16),
                          Text('Overdue', style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: 4),
                          Text('3', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w700,
                          )),
                        ],
                      ),
                    ).animate().fade(delay: 300.ms).slideY(begin: 0.1, end: 0),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Today\'s Follow-ups', style: Theme.of(context).textTheme.titleLarge),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Lead'),
                  ),
                ],
              ).animate().fade(delay: 400.ms),
              const SizedBox(height: 16),
              const SizedBox(
                height: 300,
                child: AppEmptyState(
                  message: 'No follow-ups scheduled for today.',
                  icon: Icons.check_circle_outline,
                ),
              ).animate().fade(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}

