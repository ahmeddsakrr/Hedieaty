import 'package:flutter/material.dart';

import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';


class SignupForm extends StatelessWidget {

  final VoidCallback onAuthComplete;

  const SignupForm({super.key, required this.onAuthComplete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Image Picker
        GestureDetector(
          onTap: () {
            // Add functionality for profile image picker
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(
              Icons.camera_alt,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const CustomTextField(
          label: 'Name',
          icon: Icons.person_outline,
          obscureText: false,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 10),
        const CustomTextField(
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        const CustomTextField(
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 10),
        const CustomTextField(
          label: 'Password',
          icon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        CustomButton(
          label: 'Sign Up',
          onPressed: onAuthComplete,
        ),
      ],
    );
  }
}
