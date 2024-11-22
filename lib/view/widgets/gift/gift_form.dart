import 'package:flutter/material.dart';
import '../../../old_models/gift.dart';

class GiftForm extends StatefulWidget {
  final Gift gift;
  final bool isEditable;
  final ValueChanged<Gift> onGiftChanged;

  const GiftForm({
    super.key,
    required this.gift,
    required this.isEditable,
    required this.onGiftChanged,
  });

  @override
  _GiftFormState createState() => _GiftFormState();
}

class _GiftFormState extends State<GiftForm> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late String category;
  bool isPledged = false;
  bool isNameValid = true;
  bool isCategoryValid = true;

  final List<String> categories = ['Electronics', 'Books', 'Clothes', 'Toys'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.gift.name);
    descriptionController = TextEditingController(text: widget.gift.description ?? '');
    priceController = TextEditingController(text: widget.gift.price?.toString() ?? '');

    category = categories.contains(widget.gift.category) ? widget.gift.category : 'Electronics';
    isPledged = widget.gift.status == 'Pledged';
  }

  void _validateFields() {
    setState(() {
      isNameValid = nameController.text.isNotEmpty;
      isCategoryValid = categories.contains(category);
    });
  }

  void _notifyGiftChanged() {
    _validateFields();
    if (isNameValid && isCategoryValid) {
      widget.onGiftChanged(
        widget.gift.copyWith(
          name: nameController.text,
          description: descriptionController.text,
          category: category,
          price: double.tryParse(priceController.text),
          status: isPledged ? 'Pledged' : 'Available',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    Color getStatusColor() {
      switch (widget.gift.status) {
        case 'Pledged':
          return isDarkMode ? Colors.tealAccent : Colors.teal;
        case 'Available':
          return isDarkMode ? Colors.lightGreenAccent : Colors.lightGreen;
        default:
          return theme.colorScheme.surfaceContainerHighest;
      }
    }

    final statusColor = getStatusColor();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Gift Name',
              border: const OutlineInputBorder(),
              errorText: isNameValid ? null : 'Please enter a name',
            ),
            enabled: widget.isEditable,
            onChanged: (value) => _notifyGiftChanged(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            enabled: widget.isEditable,
            maxLines: 3,
            onChanged: (value) => _notifyGiftChanged(),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: category,
            items: categories
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: widget.isEditable ? (value) {
              setState(() => category = value ?? 'Electronics');
              _notifyGiftChanged();
            } : null,
            decoration: InputDecoration(
              labelText: 'Category',
              border: const OutlineInputBorder(),
              errorText: isCategoryValid ? null : 'Please select a valid category',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
            enabled: widget.isEditable,
            onChanged: (value) => _notifyGiftChanged(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: getStatusColor().withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(
                        Icons.circle,
                        size: 12,
                        color: getStatusColor()
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isPledged ? 'Pledged' : 'Available',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch.adaptive(
                        value: isPledged,
                        onChanged: widget.isEditable
                            ? (value) {
                          setState(() {
                            isPledged = value;
                          });
                          _notifyGiftChanged();
                        }
                            : null,
                        activeColor: getStatusColor()
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
