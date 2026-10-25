import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jetstream_new/features/auth/login_screen.dart';

void main() {
  testWidgets('login screen renders the sign-in choices', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    // The logo animation repeats, so settling the whole tree would never end.
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Jetstream'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);
  });
}
