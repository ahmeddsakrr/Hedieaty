import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
import 'package:hedieaty/controller/services/auth_service.dart';

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
  await dotenv.load(fileName: ".env");
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
  late final NotificationService _notificationService;
  late final AuthService _authService;
  GlobalNotificationListener? _globalNotificationListener;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService(AppDatabase());
    _authService = AuthService(AppDatabase());
  }

  void startNotificationListener(String userId) {
    _globalNotificationListener?.dispose();
    _globalNotificationListener = GlobalNotificationListener(_notificationService);
    _globalNotificationListener!.startListening(userId);
  }

  void stopNotificationListener() {
    _globalNotificationListener?.dispose();
    _globalNotificationListener = null;
  }

  void toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: _isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: AuthPage(
        onAuthComplete: () async {
          String userId = await _authService.getCurrentUser();
          startNotificationListener(userId);
          navigateWithAnimation(
            HomePage(toggleTheme: toggleTheme),
            replace: true,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    stopNotificationListener();
    super.dispose();
  }
}
