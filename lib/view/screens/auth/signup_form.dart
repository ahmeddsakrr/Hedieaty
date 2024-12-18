import 'package:flutter/material.dart';
import 'package:hedieaty/view/components/notification.dart';
import '../../../data/local/database/app_database.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../../controller/services/auth_service.dart';

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

  final AuthService _authService = AuthService(AppDatabase());

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      final user = await _authService.signup(name, email, phone, password);
      if (user != null) {
        widget.onAuthComplete();
      } else {
        NotificationHelper.showNotification(context, 'Signup failed, try again', isSuccess: false);
      }
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
              if (value == null || value.isEmpty || !value.contains('@')) {
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
              } else if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
                return 'Please enter a valid phone number';
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
            label: 'Sign Up',
            onPressed: _signup,
          ),
        ],
      ),
    );
  }
}
