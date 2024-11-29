import 'package:flutter/material.dart';
import 'package:hedieaty/controller/enums/gift_status.dart';
import 'package:hedieaty/data/local/database/app_database.dart';
import '../../../controller/utils/date_utils.dart';

class GiftListItem extends StatelessWidget {
  final Gift gift;
  final Animation<double>? animation;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  final String? friendName;
  final DateTime? dueDate;

  final Widget? customAction;

  const GiftListItem({
    super.key,
    required this.gift,
    this.animation,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
    this.friendName,
    this.dueDate,
    this.customAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    Color getStatusColor() {
      GiftStatus status = GiftStatus.fromString(gift.status);
      switch (status) {
        case GiftStatus.pledged:
          return isDarkMode ? Colors.tealAccent : Colors.teal;
        case GiftStatus.available:
          return isDarkMode ? Colors.lightGreenAccent : Colors.lightGreen;
        default:
          return theme.colorScheme.surfaceContainerHighest;
      }
    }

    final listItemContent = Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        splashColor: theme.colorScheme.primary.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gift.imageUrl != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      gift.imageUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.card_giftcard,
                      color: theme.colorScheme.primary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gift.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Category: ${gift.category}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Price: \$${gift.price?.toStringAsFixed(2) ?? 'N/A'}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 12,
                              color: getStatusColor(),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Status: ${gift.status}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: getStatusColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (friendName != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Recipient: $friendName',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        if (dueDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Due: ${getFormattedDate(dueDate!)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (showActions && customAction == null) const SizedBox(width: 16),
                  if (showActions && customAction == null)
                    Column(
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
                  if (customAction != null) customAction!,
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return animation != null
        ? FadeTransition(
      opacity: animation!,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation!),
        child: listItemContent,
      ),
    )
        : listItemContent;
  }
}