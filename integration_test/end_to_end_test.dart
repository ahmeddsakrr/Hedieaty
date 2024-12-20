import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty/controller/enums/event_status.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final firstUserUniqueEmail = 'testuser1_$timestamp@example.com';
  final firstUserUniquePhone = '12345${Random().nextInt(99999)}';
  final secondUserUniqueEmail = 'testuser2_$timestamp@example.com';
  final secondUserUniquePhone = '1234${Random().nextInt(99999)}';
  final toggleButton = find.byKey(Key('toggleAuthModeButton'));
  final nameField = find.byKey(Key('nameField'));
  final emailField = find.byKey(Key('emailField'));
  final passwordField = find.byKey(Key('passwordField'));
  final phoneField = find.byKey(Key('phoneField'));
  final submitButton = find.byKey(Key('submitSignUpButton'));
  final homeScreen = find.text('Create Your Own Event/List');
  final eventItem = find.text('Test Event');
  final backButton = find.byTooltip('Back');
  final giftItem = find.text('Test Gift');
  final navigateToProfileButton = find.byKey(Key('navigateToProfileButton'));

  tearDown(() {
    app.clearSharedPreferenceKey('current_user_phone_number');
  });



  group('End to End Test 1', () {
    testWidgets("End to End Scenario 1", (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to Sign-Up page
      await tester.tap(toggleButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Enter valid credentials
      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, firstUserUniqueEmail);
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(phoneField, firstUserUniquePhone);

      await tester.tap(submitButton);

      // Wait for navigation to HomePage
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        while (homeScreen.evaluate().isEmpty) {
          await Future.delayed(const Duration(milliseconds: 500));
          await tester.pump();
        }
      });

      expect(homeScreen, findsAny);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      final eventListButton = find.byKey(Key('navigateToEventListButton'));
      await tester.tap(eventListButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final eventScreen = find.text('Event List');
      expect(eventScreen, findsAny);

      final createEventButton = find.byKey(Key('createEventButton'));
      await tester.tap(createEventButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final eventNameField = find.byKey(Key('eventNameField'));
      final eventCategoryField = find.byKey(Key('eventCategoryField'));
      final eventStatusField = find.byKey(Key('eventStatusField'));

      await tester.enterText(eventNameField, 'Test Event');
      await tester.enterText(eventCategoryField, 'Test Category');
      await tester.tap(eventStatusField);
      await tester.pumpAndSettle();
      final upcomingOption = find.text(EventStatus.current.name).last;
      await tester.tap(upcomingOption);
      await tester.pumpAndSettle();
      final closeEventButton = find.byKey(Key('closeEventDialogButton'));
      await tester.tap(closeEventButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));


      expect(eventItem, findsAny);

      await tester.tap(eventItem);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final giftListPage = find.text('Test Event - Gift List');
      expect(giftListPage, findsAny);

      final addGiftButton = find.byKey(Key('addGiftButton'));
      await tester.tap(addGiftButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final giftNameField = find.byKey(Key('giftNameField'));
      final giftDescriptionField = find.byKey(Key('giftDescriptionField'));
      final giftPriceField = find.byKey(Key('giftPriceField'));

      await tester.enterText(giftNameField, 'Test Gift');
      await tester.enterText(giftDescriptionField, 'Test Description');
      await tester.enterText(giftPriceField, '100');

      final saveGiftButton = find.byKey(Key('saveGiftButton'));
      await tester.tap(saveGiftButton);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(giftItem, findsAny);
      await tester.tap(backButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final publishEventButton = find.byKey(Key('publishEventButton'));
      await tester.tap(publishEventButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(backButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(navigateToProfileButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // await tester.drag(find.byKey(Key('profilePage')), const Offset(500, 0));
      await tester.dragUntilVisible(find.byKey(Key('logoutButton')), find.byKey(Key('profilePage')),const Offset(-500, 0));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      final logoutButton = find.byKey(Key('logoutButton'));
      app.clearSharedPreferenceKey('current_user_phone_number');

      await tester.tap(logoutButton);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(toggleButton, findsAny);
      //
      // await tester.tap(toggleButton);
      // await tester.pumpAndSettle(const Duration(seconds: 2));

    });
  });

  group('End to End Test 2', () {
    testWidgets("End to End Scenario 2", (WidgetTester tester) async {
      // await tester.pumpWidget(const app.MyApp());
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await tester.tap(toggleButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, secondUserUniqueEmail);
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(phoneField, secondUserUniquePhone);
      await tester.tap(submitButton);
      await tester.runAsync(() async {
        while (homeScreen.evaluate().isEmpty) {
          await Future.delayed(const Duration(milliseconds: 500));
          await tester.pump();
        }
      });

      final addFriendButton = find.byKey(Key('addFriendButton'));
      await tester.tap(addFriendButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      final friendPhoneField = find.byKey(Key('friendPhoneNumberField'));
      await tester.enterText(friendPhoneField, firstUserUniquePhone);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      final friendItem = find.text('Test User');
      expect(friendItem, findsAny);

      await tester.tap(friendItem);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(eventItem, findsAny);
      await tester.tap(eventItem);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(giftItem, findsAny);
      await tester.tap(find.byKey(Key('pledgeButton')).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(Key('confirmPledgeButton')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byKey(Key('pledgeButton')), findsNothing);
    });
  });
}
