import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lead_flow/core/widgets/app_scaffold.dart';

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
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Dashboard Route')),
                ),
              ),
            ],
          ),
          // Leads Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/leads',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Leads Route')),
                ),
              ),
            ],
          ),
          // Follow-ups Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/follow-ups',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Follow-ups Route')),
                ),
              ),
            ],
          ),
          // Settings Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Settings Route')),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
