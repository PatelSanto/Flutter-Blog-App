import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome to Flutter App'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
            },
            child: const Text('Go to Second Screen'),
          ),
        ],
      ),
    );
  }
}
