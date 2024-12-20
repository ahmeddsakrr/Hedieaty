import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Tests', () {
    testWidgets('Sign Up with Valid Credentials', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to Sign-Up page
      final toggleButton = find.byKey(Key('toggleAuthModeButton'));
      await tester.tap(toggleButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueEmail = 'testuser_$timestamp@example.com';
      final uniquePhone = '12345${Random().nextInt(99999)}';


      // Enter valid credentials
      final nameField = find.byKey(Key('nameField'));
      final emailField = find.byKey(Key('emailField'));
      final passwordField = find.byKey(Key('passwordField'));
      final phoneField = find.byKey(Key('phoneField'));

      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, uniqueEmail);
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(phoneField, uniquePhone);

      // Submit the form
      final submitButton = find.byKey(Key('submitSignUpButton'));
      await tester.tap(submitButton);

      // Wait for navigation to HomePage
      await tester.pumpAndSettle(); // Wait for initial UI update
      final homeScreen = find.text('Create Your Own Event/List');
      await tester.runAsync(() async {
        while (homeScreen.evaluate().isEmpty) {
          await Future.delayed(const Duration(milliseconds: 500));
          await tester.pump(); // Rebuild the widget tree
        }
      });

      // Verify navigation was successful
      expect(homeScreen, findsAny);
    });


    testWidgets('Sign Up with Invalid Credentials', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to Sign-Up page
      final signUpButton = find.byKey(const Key('toggleAuthModeButton'));
      await tester.tap(signUpButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Enter invalid credentials
      final nameField = find.byKey(Key('nameField'));
      final emailField = find.byKey(Key('emailField'));
      final passwordField = find.byKey(Key('passwordField'));
      final phoneField = find.byKey(Key('phoneField'));

      await tester.enterText(nameField, ''); // Missing name
      await tester.enterText(emailField, 'invalid_email'); // Invalid email format
      await tester.enterText(passwordField, ''); // Missing password
      await tester.enterText(phoneField, '1234567890');

      // Submit the form
      final submitButton = find.byKey(Key('submitSignUpButton'));
      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify error message
      expect(find.text('Please enter your password'), findsAny);
    });

    testWidgets('Sign In with Valid Credentials', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Enter valid credentials
      final passwordField = find.byKey(Key('loginPasswordField'));
      final phoneField = find.byKey(Key('loginPhoneField'));

      await tester.enterText(phoneField, '1');
      await tester.enterText(passwordField, '12345678');

      // Submit the form
      final submitButton = find.byKey(Key('submitLoginButton'));
      await tester.tap(submitButton);

      // Wait for navigation to HomePage
      await tester.pumpAndSettle(); // Wait for initial UI update
      final homeScreen = find.text('Create Your Own Event/List');
      await tester.runAsync(() async {
        while (homeScreen.evaluate().isEmpty) {
          await Future.delayed(const Duration(milliseconds: 500));
          await tester.pump(); // Rebuild the widget tree
        }
      });
      // Verify navigation was successful
      expect(homeScreen, findsAny);
    });

    testWidgets('Sign In with Invalid Credentials', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Enter invalid credentials
      final passwordField = find.byKey(Key('loginPasswordField'));
      final phoneField = find.byKey(Key('loginPhoneField'));

      await tester.enterText(phoneField, '1');
      await tester.enterText(passwordField, '');

      // Submit the form
      final submitButton = find.byKey(Key('submitLoginButton'));
      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify error message
      expect(find.text('Please enter your password'), findsAny);
    });
});
}
