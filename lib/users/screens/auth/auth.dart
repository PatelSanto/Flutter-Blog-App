import 'package:flutter/material.dart';
import 'package:flutter_blog_app/users/screens/auth/signup.dart';
import 'package:flutter_blog_app/users/widgets/auth_widgets.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _signupText(),
          const SizedBox(height: 30),
          _authButtons(context),
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

  Widget _authButtons(BuildContext context){
    return  Row(
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
        const SizedBox(width: 20,),
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
}
