import 'package:flutter/material.dart';
import '../../components/auth_title.dart';
import '../../components/form_container.dart';
import 'login_form.dart';
import 'signup_form.dart';

class AuthPage extends StatefulWidget {
  final VoidCallback onAuthComplete;

  const AuthPage({super.key, required this.onAuthComplete});

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
                  const AuthTitle(
                    title: "Gift It, Track It, Love It!",
                    subtitle: "Manage your gifts like a pro",
                  ),
                  const SizedBox(height: 30),

                  AnimatedCrossFade(
                    firstChild: FormContainer(
                      child: LoginForm(onAuthComplete: widget.onAuthComplete),
                    ),
                    secondChild: FormContainer(
                      child: SignupForm(onAuthComplete: widget.onAuthComplete),
                    ),
                    crossFadeState: isLogin
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 500),
                    firstCurve: Curves.easeInOut,
                    secondCurve: Curves.easeInOut,
                    sizeCurve: Curves.easeInOut,
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: toggleAuthMode,
                    key: const Key('toggleAuthModeButton'),
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