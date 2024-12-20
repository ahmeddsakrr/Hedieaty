import 'package:flutter/material.dart';
import 'package:hedieaty/controller/services/auth_service.dart';
import 'package:hedieaty/data/local/database/app_database.dart';
import 'package:hedieaty/view/screens/auth/auth_page.dart';
import '../../../main.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/event_expandable_list.dart';
import '../gift/pledged_gifts_page.dart';
import '../../../controller/utils/navigation_utils.dart';
import '../home/home_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final AuthService _authService = AuthService(AppDatabase());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          key: const Key('profilePage'),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ProfileHeader(),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'My Events',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: const EventExpandableList(),
                  ),
                ),
                const SizedBox(height: 10),
                buildButton(
                  context: context,
                  icon: Icons.card_giftcard,
                  text: "View My Pledged Gifts",
                  key: const Key('pledgedGiftsButton'),
                  color: theme.colorScheme.primary,
                  onPressed: () => navigateWithAnimation(const PledgedGiftsPage()),
                ),
                const SizedBox(height: 10),
                buildButton(
                  context: context,
                  icon: Icons.logout,
                  text: "Logout",
                  key: const Key('logoutButton'),
                  color: theme.colorScheme.error,
                  onPressed: () {
                    final toggleTheme = MyApp.of(context)!.toggleTheme;
                    MyApp.of(context)!.stopNotificationListener();
                    _authService.logOut();
                    navigatorKey.currentState!.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => AuthPage(
                          onAuthComplete: () async {
                            String userId = await _authService.getCurrentUser();
                            MyApp.of(context)!.startNotificationListener(userId);
                            navigateWithAnimation(
                              HomePage(toggleTheme: toggleTheme),
                              replace: true,
                            );
                          },
                        ),
                      ),
                          (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
    required key,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        key: key,
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.colorScheme.onPrimary,
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 5,
          shadowColor: theme.colorScheme.onSurface.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 10),
            Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
