import 'package:flutter/material.dart';
import 'package:hedieaty/data/remote/firebase/models/friend.dart';

class AddFriendDialog extends StatefulWidget {
  final void Function(Friend friend) onSave;
  final String userId;

  const AddFriendDialog({super.key, required this.onSave, required this.userId});

  @override
  _AddFriendDialogState createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  final TextEditingController phoneNumberController = TextEditingController();
  bool isPhoneNumberValid = true;

  void _save() {
    final phoneNumber = phoneNumberController.text.trim();

    setState(() {
      isPhoneNumberValid = phoneNumber.isNotEmpty;
    });

    if (isPhoneNumberValid) {
      final friend = Friend(
        id: 0,
        userId: widget.userId,
        friendUserId: phoneNumber,
      );

      widget.onSave(friend);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Friend'),
      content: TextField(
        controller: phoneNumberController,
        decoration: InputDecoration(
          labelText: 'Friend\'s Phone Number',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorText: isPhoneNumberValid ? null : 'Phone number cannot be empty',
        ),
        keyboardType: TextInputType.phone,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
