import 'package:flutter/material.dart';
import '../../components/auth_title.dart';
import '../../components/form_container.dart';
import 'login_form.dart';
import 'signup_form.dart';

class AuthPage extends StatefulWidget {
  final VoidCallback onAuthComplete;

  const AuthPage({Key? key, required this.onAuthComplete}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Auth Title
                  const AuthTitle(
                    title: "Gift It, Track It, Love It!",
                    subtitle: "Manage your gifts like a pro",
                  ),

                  const SizedBox(height: 30),
                  // Form Container
                  FormContainer(
                    child: isLogin
                        ? LoginForm(onAuthComplete: widget.onAuthComplete)
                        : SignupForm(onAuthComplete: widget.onAuthComplete),
                  ),
                  const SizedBox(height: 10),
                  // Toggle Button
                  TextButton(
                    onPressed: toggleAuthMode,
                    child: Text(
                      isLogin
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Login",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}