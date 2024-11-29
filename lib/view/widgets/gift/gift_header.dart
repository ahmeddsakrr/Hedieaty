import 'package:flutter/material.dart';

class GiftHeader extends StatelessWidget {
  final String? imageUrl;
  final bool isEditable;

  const GiftHeader({super.key, this.imageUrl, required this.isEditable});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            image: imageUrl != null
                ? DecorationImage(
              image: NetworkImage(imageUrl!),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: imageUrl == null
              ? Center(
            child: Icon(
              Icons.image,
              size: 100,
              color: theme.colorScheme.primary.withOpacity(0.4),
            ),
          )
              : null,
        ),
        if (isEditable)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // TODO : code to open image picker and upload image
              },
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.camera_alt),
            ),
          ),
      ],
    );
  }
}