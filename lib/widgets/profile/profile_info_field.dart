import 'package:flutter/material.dart';

class ProfileInfoField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const ProfileInfoField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  @override
  _ProfileInfoFieldState createState() => _ProfileInfoFieldState();
}

class _ProfileInfoFieldState extends State<ProfileInfoField> {
  bool isEditable = false;
  final _formKey = GlobalKey<FormState>();

  void _toggleEdit() {
    if (isEditable) {
      if (_formKey.currentState?.validate() ?? false) {
        // Save changes if validated
        setState(() {
          isEditable = false;
        });
      }
    } else {
      // Switch to edit mode
      setState(() {
        isEditable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                decoration: InputDecoration(
                  labelText: widget.label,
                  border: const OutlineInputBorder(),
                  enabled: isEditable,
                ),
                validator: widget.validator,
              ),
            ),
            IconButton(
              icon: Icon(isEditable ? Icons.check : Icons.edit),
              onPressed: _toggleEdit,
            ),
          ],
        ),
      ),
    );
  }
}
