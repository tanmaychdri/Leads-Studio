import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lead_flow/app/theme/app_theme.dart';
import 'package:lead_flow/app/router/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: LeadsStudioApp(),
    ),
  );
}

class LeadsStudioApp extends ConsumerWidget {
  const LeadsStudioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the GoRouter provider to get the router configuration
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'LeadsStudio',
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,
    );
  }
}
