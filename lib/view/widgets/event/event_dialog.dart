import 'package:flutter/material.dart';
import 'package:hedieaty/controller/enums/event_status.dart';

import '../../../data/remote/firebase/models/event.dart' as RemoteEvent;



class EventDialog extends StatefulWidget {
  final RemoteEvent.Event? event;
  final void Function(RemoteEvent.Event) onSave;
  final String userId;

  const EventDialog({super.key, this.event, required this.onSave, required this.userId});

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
    selectedStatus = widget.event?.eventDate != null
        ? EventStatus.fromDateTime(widget.event!.eventDate).name
        : EventStatus.upcoming.name;
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
      RemoteEvent.Event newEvent;

      if (widget.event != null) {
        // Editing an existing event
        newEvent = RemoteEvent.Event(
          name: nameController.text,
          category: categoryController.text,
          eventDate: selectedDate!,
          id: widget.event!.id,
          userId: widget.userId,
          isPublished: widget.event!.isPublished,
        );
      } else {
        // Adding a new event
        newEvent = RemoteEvent.Event(
          name: nameController.text,
          category: categoryController.text,
          eventDate: selectedDate!,
          id: 0,
          userId: widget.userId,
          isPublished: false,
        );
      }

      widget.onSave(newEvent);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);

    if (selectedStatus == EventStatus.current.name) {
      firstDate = now;
      lastDate = now;
    } else if (selectedStatus == EventStatus.past.name) {
      firstDate = DateTime(2000);
      lastDate = now.subtract(const Duration(days: 1));
    } else if (selectedStatus == EventStatus.upcoming.name) {
      firstDate = now.add(const Duration(days: 1));
      lastDate = DateTime(2100);
    }
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
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
              key: const Key('eventNameField'),
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
              key: const Key('eventCategoryField'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: [EventStatus.upcoming.name, EventStatus.current.name, EventStatus.past.name]
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                  if (selectedStatus == EventStatus.current.name) {
                    selectedDate = DateTime.now();
                  } else if (selectedStatus == EventStatus.past.name) {
                    selectedDate = DateTime.now().subtract(const Duration(days: 1));
                  } else if (selectedStatus == EventStatus.upcoming.name) {
                    selectedDate = DateTime.now().add(const Duration(days: 1));
                  }
                  isDateValid = true; // Reset validation state
                });
              },
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              key: const Key('eventStatusField'),
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
                  key: const Key('eventDateField'),
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
          key: const Key('closeEventDialogButton'),
        ),
      ],
    );
  }
}
