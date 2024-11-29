import 'package:flutter/material.dart';
import 'package:hedieaty/controller/enums/event_status.dart';

import '../../../data/local/database/app_database.dart';

const String placeholderUserId = '1234567890'; // Placeholder for current user ID


class EventDialog extends StatefulWidget {
  final Event? event;
  final void Function(Event) onSave;

  const EventDialog({super.key, this.event, required this.onSave});

  @override
  _EventDialogState createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  String selectedStatus = EventStatus.upcoming.name;
  DateTime? selectedDate;

  bool isNameValid = true;
  bool isCategoryValid = true;
  bool isDateValid = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.event?.name ?? '');
    categoryController = TextEditingController(text: widget.event?.category ?? '');
    selectedStatus = EventStatus.fromDateTime(widget.event!.eventDate).name;
    selectedDate = widget.event?.eventDate;
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
      isDateValid = selectedDate != null;
    });

    if (isNameValid && isCategoryValid && isDateValid) {
      Event newEvent;

      if (widget.event != null) {
        // Editing an existing event
        newEvent = Event(
          name: nameController.text,
          category: categoryController.text,
          eventDate: selectedDate!,
          id: widget.event!.id,
          userId: widget.event!.userId,
        );
      } else {
        // Adding a new event
        newEvent = Event(
          name: nameController.text,
          category: categoryController.text,
          eventDate: selectedDate!,
          id: 0,
          userId: placeholderUserId,
        );
      }

      widget.onSave(newEvent);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        isDateValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.event != null ? 'Edit Event' : 'Add Event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorText: isNameValid ? null : 'Event name is required',
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
              items: ['Upcoming', 'Current', 'Past']
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? 'No date selected'
                      : 'Date: ${selectedDate!.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    color: isDateValid ? Colors.grey[600] : Colors.red,
                  ),
                ),
                TextButton(
                  onPressed: _selectDate,
                  child: const Text("Select Date"),
                ),
              ],
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
          child: Text(widget.event != null ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
