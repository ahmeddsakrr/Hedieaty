import 'package:flutter/material.dart';
import 'package:hedieaty/data/remote/firebase/models/notification.dart' as NotificationModel;

import 'package:hedieaty/controller/utils/date_utils.dart';

class NotificationListItem extends StatelessWidget {
  final NotificationModel.Notification notification;
  final VoidCallback onMarkAsRead;

  const NotificationListItem({
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
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Created: ${getFormattedDate(notification.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 14,
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