import 'package:flutter/material.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/event_expandable_list.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const EventExpandableList(),
              ),
              _pledgedGiftsButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pledgedGiftsButton(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: theme.colorScheme.secondary),
          ),
          child: Center(
            child: Text(
              "View My Pledged Gifts",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
