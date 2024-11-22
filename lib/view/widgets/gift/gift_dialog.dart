import 'package:flutter/material.dart';
import '../../../old_models/gift.dart';

class GiftDialog extends StatefulWidget {
  final Gift? gift;
  final void Function(Gift) onSave;

  const GiftDialog({super.key, this.gift, required this.onSave});

  @override
  _GiftDialogState createState() => _GiftDialogState();
}

class _GiftDialogState extends State<GiftDialog> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  String selectedStatus = 'Available';

  bool isNameValid = true;
  bool isCategoryValid = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.gift?.name ?? '');
    categoryController = TextEditingController(text: widget.gift?.category ?? '');
    selectedStatus = widget.gift?.status ?? 'Available';
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      isNameValid = nameController.text.isNotEmpty;
      isCategoryValid = categoryController.text.isNotEmpty;
    });

    if (isNameValid && isCategoryValid) {
      widget.onSave(Gift(
        name: nameController.text,
        category: categoryController.text,
        status: selectedStatus,
      ));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.gift != null ? 'Edit Gift' : 'Add Gift'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Gift Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorText: isNameValid ? null : 'Gift name is required',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorText: isCategoryValid ? null : 'Category is required',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: ['Available', 'Pledged']
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(widget.gift != null ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
