import 'package:flutter/material.dart';
import '../../models/event.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(animation), // Apply the animation
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
          child: ListTile(
            onTap: onTap, // Trigger the onTap callback to navigate
            leading: const Icon(Icons.event),
            title: Text(event.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: ${event.category}'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Status: ${event.status}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
            splashColor: Colors.purpleAccent.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
