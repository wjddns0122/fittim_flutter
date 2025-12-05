import 'package:flutter_test/flutter_test.dart';
import 'package:fittim_flutter/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(FittimApp());

    // Verify that the welcome message is displayed.
    expect(find.text('Welcome to Fittim'), findsOneWidget);
  });
}
