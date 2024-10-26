import 'package:flutter/material.dart';
import '../../models/gift.dart';

class GiftListItem extends StatelessWidget {
  final Gift gift;
  final Animation<double>? animation;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const GiftListItem({
    super.key,
    required this.gift,
    this.animation,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusColor = gift.status == 'Pledged'
        ? (isDarkMode ? Colors.greenAccent : Colors.teal[400])
        : Colors.orangeAccent;

    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    final listItemContent = Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (gift.imageUrl != null)
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(gift.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.all(8.0),
              color: Colors.grey[300],
              child: Icon(Icons.image_not_supported, color: Colors.grey[500]),
            ),
          Expanded(
            child: ListTile(
              title: Text(
                gift.name,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category: ${gift.category}',
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Description: ${gift.description ?? ''}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: \$${gift.price?.toStringAsFixed(2) ?? 'N/A'}',
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Status: ${gift.status}',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: showActions
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                    color: textColor,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                    color: textColor,
                  ),
                ],
              )
                  : null,
            ),
          ),
        ],
      ),
    );

    return animation != null
        ? SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation!),
      child: listItemContent,
    )
        : listItemContent;
  }
}
