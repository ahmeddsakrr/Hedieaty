import 'package:flutter/material.dart';
import 'package:hedieaty/data/remote/firebase/models/notification.dart' as NotificationModel;
import 'package:hedieaty/controller/services/notification_service.dart';

import '../../../data/local/database/app_database.dart';
import '../../widgets/notification/notification_list_item.dart';

class NotificationsListPage extends StatefulWidget {
  final String userId;
  const NotificationsListPage({super.key, required this.userId});

  @override
  _NotificationsListPageState createState() => _NotificationsListPageState();
}

class _NotificationsListPageState extends State<NotificationsListPage> {
  final NotificationService _notificationService = NotificationService(AppDatabase());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: StreamBuilder<List<NotificationModel.Notification>>(
        stream: _notificationService.getNotifications(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications available.',
                style: TextStyle(
                  color: isDarkMode
                      ? theme.colorScheme.onSurface.withOpacity(0.7)
                      : theme.colorScheme.onSurfaceVariant,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationListItem(
                notification: notifications[index],
                onMarkAsRead: () async {
                  await _notificationService.markNotificationAsRead(notifications[index]);
                  setState(() {});
                },
              );
            },
          );
        },
      ),
    );
  }
}

