import 'package:flutter/material.dart';
import 'package:blog_app/users/widgets/auth_widgets.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:blog_app/users/widgets/snackbar.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _authImage(),
            const SizedBox(height: 20),
            _signupText(),
            const SizedBox(height: 30),
            _authButtons(context),
            const SizedBox(height: 30),
            _googleButton(context),
          ],
        ),
      ),
    );
  }

  Widget _authImage() {
    return Image.asset(
      'assets/images/login.jpg',
      fit: BoxFit.contain,
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

  Widget _authButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: authButton(
            ontap: () {
              // Navigate to Sign Up Page
              Navigator.pushNamed(context, "/signup");
            },
            buttonName: "Sign Up",
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: authButton(
            ontap: () {
              // Navigate to Sign In Page
              Navigator.pushNamed(context, "/login");
            },
            buttonName: "Log in",
          ),
        ),
      ],
    );
  }

  Widget _googleButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GoogleAuthButton(
          onPressed: () {
            snackbarToast(
                context: context,
                title: "This function is still in development!",
                icon: Icons.error);
          },
          style: const AuthButtonStyle(
            shadowColor: Colors.blue,
          ),
          themeMode: ThemeMode.light,
        ),
      ],
    );
  }
}
