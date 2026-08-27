import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // ProviderScope is required for Riverpod to work
    const ProviderScope(
      child: LeadFlowApp(),
    ),
  );
}

class LeadFlowApp extends ConsumerWidget {
  const LeadFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is a temporary MaterialApp.
    // In upcoming steps, we will replace this with MaterialApp.router 
    // to use GoRouter, and apply our custom theme system.
    return MaterialApp(
      title: 'LeadFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('LeadFlow Foundation Started'),
        ),
      ),
    );
  }
}
