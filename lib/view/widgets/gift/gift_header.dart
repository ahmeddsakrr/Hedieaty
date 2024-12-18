import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class GiftHeader extends StatefulWidget {
  final String? imageUrl;
  final bool isEditable;
  final Function(String) onImageSelected;

  const GiftHeader({super.key, this.imageUrl, required this.isEditable, required this.onImageSelected});

  @override
  _GiftHeaderState createState() => _GiftHeaderState();
}

class _GiftHeaderState extends State<GiftHeader> {
  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    if (await Permission.photos.request().isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        widget.onImageSelected(image.path);
      }
    } else {
      print("Permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            image: widget.imageUrl != null
                ? DecorationImage(
              image: NetworkImage(widget.imageUrl!),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: widget.imageUrl == null
              ? Center(
            child: Icon(
              Icons.image,
              size: 100,
              color: theme.colorScheme.primary.withOpacity(0.4),
            ),
          )
              : null,
        ),
        if (widget.isEditable)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _pickImage,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.camera_alt),
            ),
          ),
      ],
    );
  }
}