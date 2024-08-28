import 'package:flutter/material.dart';
import 'package:flutter_blog_app/users/screens/home_screen.dart';
import 'package:flutter_blog_app/users/screens/signup_screen.dart';
import 'package:flutter_blog_app/utils.dart';

void main() {
  setup().then((_) {
    runApp(MyApp());
  });
}

Future<void> setup() async {
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Map<String, WidgetBuilder> routes = {
    // 'homePage': (context) => const HomeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 141, 107, 198)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
