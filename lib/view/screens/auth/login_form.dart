import 'package:flutter/material.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class LoginForm extends StatelessWidget {
  final VoidCallback onAuthComplete;

  const LoginForm({super.key, required this.onAuthComplete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          label: 'Login',
          onPressed: onAuthComplete,
        ),
      ],
    );
  }
}
