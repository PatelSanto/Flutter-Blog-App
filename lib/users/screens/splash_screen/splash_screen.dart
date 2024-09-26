import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, '/home');
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 400,
          width: 400,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/logo.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
