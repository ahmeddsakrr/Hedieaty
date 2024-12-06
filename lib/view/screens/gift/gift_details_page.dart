import 'package:flutter/material.dart';
import 'package:hedieaty/controller/enums/gift_status.dart';
import '../../widgets/gift/gift_header.dart';
import '../../widgets/gift/gift_form.dart';
import '../../../data/remote/firebase/models/gift.dart';

class GiftDetailsPage extends StatefulWidget {
  final Gift? gift;
  final bool isEditMode;
  final eventId;

  const GiftDetailsPage({super.key, this.gift, required this.isEditMode, required this.eventId});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  late Gift editableGift;
  bool isLocked = false;
  bool isLockedStatus = false;


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
          id: 0, // database will assign an ID
          eventId: widget.eventId
        );
    GiftStatus status = GiftStatus.fromString(editableGift.status);
    isLockedStatus = status == GiftStatus.pledged;
    isLocked = widget.isEditMode && isLockedStatus;
  }

  void _saveGift() {
    // Check for empty fields
    if (editableGift.name.isEmpty || editableGift.category.isEmpty) {
      _showValidationError();
      return;
    }

    setState(() {
      GiftStatus status = GiftStatus.fromString(editableGift.status);
      isLockedStatus = status == GiftStatus.pledged;
      isLocked = isLockedStatus;
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
