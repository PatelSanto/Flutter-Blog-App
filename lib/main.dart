import 'package:flutter/material.dart';
import 'package:flutter_blog_app/users/screens/auth/auth.dart';
import 'package:flutter_blog_app/users/screens/auth/login.dart';
import 'package:flutter_blog_app/users/screens/auth/user_profile.dart';
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

  final AuthService _authService = GetIt.instance.get<AuthService>();

  final Map<String, WidgetBuilder> routes = {
    '/home': (context) => const HomeScreen(),
    '/auth': (context) => const Auth(),
    '/login': (context) => const LoginScreen(),
    '/signup': (context) => const SignupScreen(),
    '/profile': (context) => const  UserProfileScreen(),
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
        home: _authService.checkLogin(),
        );
  }
}
