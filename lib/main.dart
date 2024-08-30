import 'package:flutter/material.dart';
import 'package:flutter_blog_app/users/screens/auth/auth.dart';
import 'package:flutter_blog_app/users/screens/auth/login.dart';
import 'package:flutter_blog_app/users/screens/home/home_screen.dart';
import 'package:flutter_blog_app/users/screens/auth/signup.dart';
import 'package:flutter_blog_app/users/services/auth_services.dart';
import 'package:flutter_blog_app/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // final AuthService _authService = GetIt.instance.get<AuthService>();

  final Map<String, WidgetBuilder> routes = {
    '/home': (context) => const HomeScreen(),
    '/login': (context) => const LoginScreen(),
    '/signup': (context) => const SignupScreen(),
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
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home:
          //const HomeScreen()
          const Auth(),
      // home: _authService.checkLogin(),
    );
  }
}
