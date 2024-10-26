import 'package:flutter/material.dart';

class GiftHeader extends StatelessWidget {
  final String? imageUrl;
  final bool isEditable;

  const GiftHeader({super.key, this.imageUrl, required this.isEditable});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            image: imageUrl != null
                ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                : null,
          ),
          child: imageUrl == null
              ? Center(
            child: Icon(
              Icons.image,
              size: 100,
              color: Colors.grey[400],
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
                // Code to open image picker and upload image
              },
              child: const Icon(Icons.camera_alt),
            ),
          ),
      ],
    );
  }
}
