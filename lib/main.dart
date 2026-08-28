import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/app/theme/app_theme.dart';
import 'package:leads_studio/app/router/app_router.dart';
import 'package:leads_studio/features/notifications/data/notification_service.dart';
import 'package:leads_studio/features/leads/presentation/providers/leads_provider.dart';
import 'package:leads_studio/features/auth/presentation/providers/auth_provider.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  // Initialize notifications
  try { await NotificationService().initialize();
    await NotificationService().requestPermissions();
  } catch(e, st) { print('INIT ERROR: $e\n$st'); }

  runApp(
    const ProviderScope(
      child: LeadsStudioApp(),
    ),
  );
}

class LeadsStudioApp extends ConsumerStatefulWidget {
  const LeadsStudioApp({super.key});

  @override
  ConsumerState<LeadsStudioApp> createState() => _LeadsStudioAppState();
}

class _LeadsStudioAppState extends ConsumerState<LeadsStudioApp> {
  StreamSubscription? _notifSubscription;

  @override
  void initState() {
    super.initState();
    
    // Step 12: Startup reconciliation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reconcileStartupNotifications();
    });

    // Listen to notification clicks
    _notifSubscription = NotificationService().onNotificationClick.listen((String payload) {
      final goRouter = ref.read(goRouterProvider);
      
      if (payload.startsWith('lead_followup:') || payload.startsWith('lead_reminder:')) {
        final parts = payload.split(':');
        if (parts.length > 1) {
          goRouter.push('/leads/${parts[1]}');
        }
      } else if (payload == 'daily_summary') {
        goRouter.push('/follow-ups');
      } else if (payload == 'overdue_summary') {
        goRouter.push('/follow-ups');
      }
    });
  }

  Future<void> _reconcileStartupNotifications() async {
    try {
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        final leadService = ref.read(leadServiceProvider);
        await leadService.reconcileAllNotifications();
      }
    } catch (e) {
      // Ignored
    }
  }

  @override
  void dispose() {
    _notifSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Leads Studio',
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,
    );
  }
}