import 'package:flutter/material.dart';
import 'package:hedieaty/controller/enums/gift_status.dart';
import 'package:hedieaty/controller/services/imgbb_service.dart';
import '../../components/notification.dart';
import '../../widgets/gift/gift_header.dart';
import '../../widgets/gift/gift_form.dart';
import 'package:hedieaty/data/remote/firebase/models/gift.dart';

class GiftDetailsPage extends StatefulWidget {
  final Gift? gift;
  final bool isEditMode;
  final eventId;
  final bool viewOnly;

  const GiftDetailsPage({super.key, this.gift, required this.isEditMode, required this.eventId, required this.viewOnly});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  final ImgbbService _imgbbService = ImgbbService();
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
    isLocked = widget.isEditMode && isLockedStatus || widget.viewOnly;
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
    NotificationHelper.showNotification(context, 'Please fill out all fields', isSuccess: false);
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
                onImageSelected: (imagePath) async {
                  final imageUrl = await _imgbbService.uploadImage(imagePath);
                  setState(() {
                    editableGift.imageUrl = imageUrl;
                  });
                },
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
