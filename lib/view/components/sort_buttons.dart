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
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ElevatedButton(
              onPressed: onSortByName,
              style: ElevatedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary,
                backgroundColor: theme.colorScheme.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text("Sort by Name"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onSortByCategory,
              style: ElevatedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary,
                backgroundColor: theme.colorScheme.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text("Sort by Category"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onSortByStatus,
              style: ElevatedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary,
                backgroundColor: theme.colorScheme.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text("Sort by Status"),
            ),
          ],
        ),
      ),
    );
  }
}
