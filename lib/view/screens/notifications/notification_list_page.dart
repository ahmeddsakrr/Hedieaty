// notifications_page.dart
import 'package:flutter/material.dart';
import 'package:hedieaty/data/remote/firebase/models/notification.dart' as NotificationModel;
import 'package:hedieaty/controller/services/notification_service.dart';

import '../../../data/local/database/app_database.dart';
import 'package:hedieaty/controller/utils/date_utils.dart';

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
              return NotificationItem(
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

class NotificationItem extends StatelessWidget {
  final NotificationModel.Notification notification;
  final VoidCallback onMarkAsRead;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isRead = notification.isRead;

    Color borderColor = isRead ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.primary;
    Color iconColor = isRead ? theme.colorScheme.primary.withOpacity(0.5) : theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onMarkAsRead,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                  child: Icon(
                    isRead ? Icons.notifications : Icons.notifications_active,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Created: ${getFormattedDate(notification.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                if (!isRead)
                  IconButton(
                    icon: const Icon(Icons.done),
                    color: theme.colorScheme.primary,
                    onPressed: onMarkAsRead,
                    tooltip: 'Mark as Read',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}