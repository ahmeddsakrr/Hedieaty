import 'package:firebase_core/firebase_core.dart';
import 'package:hedieaty/view/widgets/notification/global_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'data/local/database/app_database.dart';
import 'data/local/database/database_seeder.dart';
import 'view/styles/app_theme.dart';
import 'view/screens/home/home_page.dart';
import 'view/screens/auth/auth_page.dart';
import 'controller/utils/navigation_utils.dart';
import 'controller/services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> clearSharedPreferenceKey(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final db = AppDatabase();
  //
  // final seeder = DatabaseSeeder(db);
  // await seeder.seed(); // Run this only in debug mode or for testing

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await clearSharedPreferenceKey('current_user_phone_number');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  void toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService(AppDatabase());

    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: _isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: GlobalNotificationListener(
        notificationService: notificationService,
        // userId: 'currentUserId',
        child: AuthPage(
          onAuthComplete: () {
            navigateWithAnimation(
              HomePage(toggleTheme: toggleTheme),
              replace: true,
            );
          },
        ),
      ),
    );
  }
}
