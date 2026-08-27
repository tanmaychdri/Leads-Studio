import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// We use a Provider to expose the router, which allows us to handle
// authentication redirects or state-based routing easily in the future.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Dashboard Route')),
        ),
      ),
      GoRoute(
        path: '/leads',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Leads Route')),
        ),
      ),
      GoRoute(
        path: '/follow-ups',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Follow-ups Route')),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Settings Route')),
        ),
      ),
    ],
  );
});
