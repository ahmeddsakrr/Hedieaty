import 'package:flutter/material.dart';

import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';


class SignupForm extends StatefulWidget {
  final VoidCallback onAuthComplete;

  const SignupForm({super.key, required this.onAuthComplete});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signup() {
    if (_formKey.currentState!.validate()) {
      widget.onAuthComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Name',
            icon: Icons.person_outline,
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomButton(
            label: 'Sign Up',
            onPressed: _signup,
          ),
        ],
      ),
    );
  }
}
