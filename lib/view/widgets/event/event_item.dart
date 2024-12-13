import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../controller/enums/event_status.dart';
import '../../../data/remote/firebase/models/event.dart' as RemoteEvent;

class EventItem extends StatelessWidget {
  final RemoteEvent.Event event;
  final Animation<double> animation;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final bool canManageEvents;

  const EventItem({
    super.key,
    required this.event,
    required this.animation,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.canManageEvents,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    Color getStatusColor() {
      switch (EventStatus.fromDateTime(event.eventDate)) {
        case EventStatus.upcoming:
          return isDarkMode ? Colors.amber.shade500 : Colors.amber.shade200;
        case EventStatus.current:
          return isDarkMode ? Colors.amber.shade700 : Colors.amber.shade400;
        case EventStatus.past:
          return isDarkMode ? Colors.amber.shade900 : Colors.amber.shade600;
        default:
          return theme.colorScheme.surfaceContainerHighest;
      }
    }

    String getFormattedDate(DateTime date) {
      return DateFormat.yMMMd().format(date);
    }

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(animation),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  getFormattedDate(event.eventDate),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          if (canManageEvents)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: onEdit,
                              color: theme.colorScheme.onSurface,
                            ),
                          if (canManageEvents)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: onDelete,
                              color: theme.colorScheme.onSurface,
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: getStatusColor(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            EventStatus.fromDateTime(event.eventDate).name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
