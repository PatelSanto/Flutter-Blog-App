import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _signupText(),
          _signupForm(),
          _signupButton(),
          _forgotPassword(),
          _loginButton(),
        ],
      ),
    );
  }

  Widget _signupText() {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Get Started...\n\n",
            style: TextStyle(fontSize: 18),
          ),
          TextSpan(
            text: "Publish Your Passion in you own way...",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _signupForm() {}

  _signupButton() {}

  _forgotPassword() {}

  _loginButton() {}
}
