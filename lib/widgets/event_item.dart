import 'package:flutter/material.dart';

class EventItem extends StatelessWidget {
  final String eventName;
  final String category;
  final String status;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  EventItem({
    required this.eventName,
    required this.category,
    required this.status,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(eventName),
        subtitle: Text('Category: $category\nStatus: $status'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
