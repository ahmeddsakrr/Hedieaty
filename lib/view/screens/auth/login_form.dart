import 'package:flutter/material.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onAuthComplete;

  const LoginForm({super.key, required this.onAuthComplete});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
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
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomButton(
            label: 'Login',
            onPressed: _login,
          ),
        ],
      ),
    );
  }
}
