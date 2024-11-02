import 'package:flutter/material.dart';
import '../../old_models/event.dart';
import 'package:intl/intl.dart';

class EventItem extends StatelessWidget {
  final Event event;
  final Animation<double> animation;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const EventItem({
    super.key,
    required this.event,
    required this.animation,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    Color getStatusColor() {
      switch (event.status) {
        case 'Upcoming':
          return isDarkMode ? Colors.amber.shade500 : Colors.amber.shade200;
        case 'Current':
          return isDarkMode ? Colors.amber.shade700 : Colors.amber.shade400;
        case 'Past':
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
                                  getFormattedDate(event.date),
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
                          IconButton(
                            icon: Icon(Icons.edit, color: theme.colorScheme.onSurface),
                            onPressed: onEdit,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: theme.colorScheme.onSurface),
                            onPressed: onDelete,
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
                            event.status,
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
