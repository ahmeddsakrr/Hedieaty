import 'package:flutter/material.dart';
import '../../models/gift.dart';
import '../../widgets/gift/gift_header.dart';
import '../../widgets/gift/gift_form.dart';

class GiftDetailsPage extends StatefulWidget {
  final Gift? gift;
  final bool isEditMode;

  const GiftDetailsPage({super.key, this.gift, required this.isEditMode});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  late Gift editableGift;
  bool isLocked = false;

  @override
  void initState() {
    super.initState();
    editableGift = widget.gift ??
        Gift(
          name: '',
          category: 'Electronics',
          status: 'Available',
          description: '',
          price: 0.0,
          imageUrl: null,
        );
    isLocked = widget.isEditMode && editableGift.status == 'Pledged';
  }

  void _saveGift() {
    // Check for empty fields
    if (editableGift.name.isEmpty || editableGift.category.isEmpty) {
      _showValidationError();
      return;
    }

    setState(() {
      isLocked = editableGift.status == 'Pledged';
    });
    Navigator.of(context).pop(editableGift);
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill out all fields.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? "Edit Gift" : "Add Gift"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GiftHeader(
                imageUrl: editableGift.imageUrl,
                isEditable: !isLocked,
              ),
              GiftForm(
                gift: editableGift,
                isEditable: !isLocked,
                onGiftChanged: (updatedGift) {
                  setState(() {
                    editableGift = updatedGift;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isLocked
          ? null
          : FloatingActionButton(
        heroTag: "gift_details_save",
        onPressed: _saveGift,
        child: const Icon(Icons.save),
      ),
    );
  }
}
