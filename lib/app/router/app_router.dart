import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leads_studio/core/widgets/app_scaffold.dart';
import 'package:leads_studio/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:leads_studio/features/follow_ups/presentation/screens/follow_ups_screen.dart';
import 'package:leads_studio/features/leads/presentation/screens/leads_screen.dart';
import 'package:leads_studio/features/leads/presentation/screens/lead_form_screen.dart';
import 'package:leads_studio/features/leads/presentation/screens/lead_details_screen.dart';

import 'package:leads_studio/features/notifications/presentation/screens/notification_settings_screen.dart';
import 'package:leads_studio/features/settings/presentation/settings_screen.dart';
import 'package:leads_studio/features/auth/presentation/screens/login_screen.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'package:leads_studio/features/drive/presentation/screens/connect_drive_screen.dart';
import 'package:leads_studio/features/drive/presentation/screens/select_file_screen.dart';
import 'package:leads_studio/features/excel/presentation/screens/worksheet_selection_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // Create a Listenable that updates when auth state changes
  final authNotifier = ValueNotifier<bool>(false);
  
  ref.listen(
    authProvider.select((state) => state.user != null),
    (_, isAuth) {
      authNotifier.value = isAuth;
    },
  );

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';
      final authState = ref.read(authProvider);
      final isAuth = authState.user != null;



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
        routes: [
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationSettingsScreen(),
          ),
        ],
      ),
      StatefulShellRoute(
        builder: (context, state, navigationShell) {
          return AppScaffold(navigationShell: navigationShell);
        },
        navigatorContainerBuilder: (context, navigationShell, children) {
          return Stack(
            children: children.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;
              final isActive = index == navigationShell.currentIndex;

              return AnimatedOpacity(
                opacity: isActive ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: IgnorePointer(
                  ignoring: !isActive,
                  child: TickerMode(
                    enabled: isActive,
                    child: child,
                  ),
                ),
              );
            }).toList(),
          );
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
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const LeadFormScreen(),
                  ),
                  GoRoute(
                    path: 'edit/:id',
                    builder: (context, state) => LeadFormScreen(existingLeadId: state.pathParameters['id']),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => LeadDetailsScreen(id: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'follow-ups',
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

