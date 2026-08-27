import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lead_flow/core/widgets/app_scaffold.dart';
import 'package:lead_flow/features/dashboard/presentation/dashboard_screen.dart';
import 'package:lead_flow/features/leads/presentation/leads_screen.dart';
import 'package:lead_flow/features/follow_ups/presentation/follow_ups_screen.dart';
import 'package:lead_flow/features/settings/presentation/settings_screen.dart';

// We use a Provider to expose the router, which allows us to handle
// authentication redirects or state-based routing easily in the future.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Leads Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/leads',
                builder: (context, state) => const LeadsScreen(),
              ),
            ],
          ),
          // Follow-ups Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/follow-ups',
                builder: (context, state) => const FollowUpsScreen(),
              ),
            ],
          ),
          // Settings Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
