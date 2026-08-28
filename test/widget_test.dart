import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leads_studio/main.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: LeadsStudioApp(),
      ),
    );

    // Give the router time to push the initial location
    await tester.pumpAndSettle();

    // Verify that our dashboard screen is present by looking for its welcome message.
    expect(find.text('Dashboard'), findsWidgets);
  });
}
