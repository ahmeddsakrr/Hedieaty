import 'package:flutter/material.dart';
import '../../models/gift.dart';

class GiftListItem extends StatelessWidget {
  final Gift gift;
  final Animation<double> animation;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GiftListItem({
    required this.gift,
    required this.animation,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final statusColor = gift.status == 'Pledged'
        ? (isDarkMode ? Colors.greenAccent : Colors.teal[400])
        : Colors.orangeAccent;

    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        color: backgroundColor,
        child: Row(
          children: [
            Container(
              width: 8,
              height: 80,
              color: statusColor,
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
                      ),
                    ),
                    const SizedBox(height: 4),
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
                trailing: Row(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
