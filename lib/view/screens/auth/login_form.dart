import 'package:flutter/material.dart';
import '../../../data/local/database/app_database.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../../controller/services/auth_service.dart';

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

  final AuthService _authService = AuthService(AppDatabase());

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      final user = await _authService.login(phone, password);
      if (user != null) {
        widget.onAuthComplete();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid phone number or password")),
        );
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
