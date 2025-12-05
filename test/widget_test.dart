// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:fittim_flutter/main.dart'; // Ensure MyApp is exported from main.dart

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Ensure MyApp is the correctly named class in lib/main.dart
    await tester.pumpWidget(const MyApp());

    // Simple check - verify we have a placeholder or just pump without crashing
    // Since our app starts with Splash, we might search for Splash content
    // or just pass if it renders.
    expect(find.byType(MyApp), findsOneWidget);
  });
}
