import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_studio/core/widgets/app_scaffold.dart';
import 'package:leads_studio/features/dashboard/presentation/dashboard_screen.dart';
import 'package:leads_studio/features/leads/presentation/leads_screen.dart';
import 'package:leads_studio/features/follow_ups/presentation/follow_ups_screen.dart';
import 'package:leads_studio/features/settings/presentation/settings_screen.dart';
import 'package:leads_studio/features/auth/presentation/screens/login_screen.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/drive/presentation/screens/connect_drive_screen.dart';
import 'package:leads_studio/features/drive/presentation/screens/select_file_screen.dart';
import 'package:leads_studio/features/excel/presentation/screens/worksheet_selection_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // Only rebuild GoRouter if authentication status changes (login/logout)
  final isAuth = ref.watch(authProvider.select((state) => state.user != null));

  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';

      // Read current state directly to avoid rebuilding Router
      final authState = ref.read(authProvider);

      if (authState.isLoading && !isAuth) {
        return null; // Wait for initialization
      }

      if (!isAuth && !isLoggingIn) {
        return '/login';
      }

      if (isAuth && isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/drive/connect',
        builder: (context, state) => const ConnectDriveScreen(),
      ),
      GoRoute(
        path: '/excel/preview',
        builder: (context, state) => const WorksheetSelectionScreen(),
      ),
      GoRoute(
        path: '/drive/select',
        builder: (context, state) => const SelectFileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/leads',
                builder: (context, state) => const LeadsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/follow-ups',
                builder: (context, state) => const FollowUpsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

