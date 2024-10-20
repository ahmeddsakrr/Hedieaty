import 'package:flutter/material.dart';

class SortButtons extends StatelessWidget {
  final VoidCallback onSortByName;
  final VoidCallback onSortByCategory;
  final VoidCallback onSortByStatus;

  SortButtons({
    required this.onSortByName,
    required this.onSortByCategory,
    required this.onSortByStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        child: Row(
          children: [
            ElevatedButton(
              onPressed: onSortByName,
              child: Text("Sort by Name"),
            ),
            SizedBox(width: 10), // Spacing between buttons
            ElevatedButton(
              onPressed: onSortByCategory,
              child: Text("Sort by Category"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: onSortByStatus,
              child: Text("Sort by Status"),
            ),
          ],
        ),
      ),
    );
  }
}
