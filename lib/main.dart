import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'data/local/database/app_database.dart';
import 'data/local/database/database_seeder.dart';
import 'view/styles/app_theme.dart';
import 'view/screens/home/home_page.dart';
import 'view/screens/auth/auth_page.dart';
import 'controller/utils/navigation_utils.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final db = AppDatabase();
  //
  // final seeder = DatabaseSeeder(db);
  // await seeder.seed(); // Run this only in debug mode or for testing

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: _isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: AuthPage(
        onAuthComplete: () {
          navigateWithAnimation(
            HomePage(toggleTheme: toggleTheme),
            replace: true,
          );
        },
      ),
    );
  }
}
