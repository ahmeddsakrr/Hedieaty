import 'package:flutter/material.dart';

class SortButtons extends StatelessWidget {
  final VoidCallback onSortByName;
  final VoidCallback onSortByCategory;
  final VoidCallback onSortByStatus;

  const SortButtons({super.key,
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
              child: const Text("Sort by Name"),
            ),
            const SizedBox(width: 10), // Spacing between buttons
            ElevatedButton(
              onPressed: onSortByCategory,
              child: const Text("Sort by Category"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onSortByStatus,
              child: const Text("Sort by Status"),
            ),
          ],
        ),
      ),
    );
  }
}
