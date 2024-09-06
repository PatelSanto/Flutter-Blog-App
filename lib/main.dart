import 'package:flutter/material.dart';
import 'package:flutter_blog_app/constants/constants.dart';
import 'package:flutter_blog_app/users/screens/auth/auth.dart';
import 'package:flutter_blog_app/users/screens/auth/login.dart';
import 'package:flutter_blog_app/users/screens/auth/user_profile.dart';
import 'package:flutter_blog_app/users/screens/auth/user_profile_edit_page.dart';
import 'package:flutter_blog_app/users/screens/home/home_screen.dart';
import 'package:flutter_blog_app/users/screens/auth/signup.dart';
import 'package:flutter_blog_app/users/services/auth_services.dart';
import 'package:flutter_blog_app/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setup().then((_) {
    runApp(ProviderScope(child: MyApp()));
  });
}

// Define a global key for the navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    '/profile': (context) => const UserProfileScreen(),
    '/profile_edit_page': (context) => const ProfileEditPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Constants.backgroundColor,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: _authService.checkLogin(),
    );
  }
}
