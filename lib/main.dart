import 'package:blog_app/admin/admin_home.dart';
import 'package:blog_app/admin/admin_login.dart';
import 'package:blog_app/users/screens/auth/user%20profile%20screens/favorite_blogs.dart';
import 'package:blog_app/users/screens/auth/user%20profile%20screens/myblogs_screen.dart';
import 'package:blog_app/users/screens/auth/user%20profile%20screens/settings_screen.dart';
import 'package:blog_app/users/screens/home/category%20screens/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/constants/constants.dart';
import 'package:blog_app/users/screens/auth/auth%20screens/auth.dart';
import 'package:blog_app/users/screens/auth/auth%20screens/login.dart';
import 'package:blog_app/users/screens/auth/user%20profile%20screens/user_profile.dart';
import 'package:blog_app/users/screens/auth/user%20profile%20screens/user_profile_edit_page.dart';
import 'package:blog_app/users/screens/home/home_screen.dart';
import 'package:blog_app/users/screens/auth/auth%20screens/signup.dart';
import 'package:blog_app/users/services/auth_services.dart';
import 'package:blog_app/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setup().then((_) {
    runApp(ProviderScope(
      child: MyApp(),
    ));
  });
}

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
    '/settings': (context) => const SettingsScreen(),
    '/categories': (context) => CategoryScreen(),
    '/myblogs': (context) => const MyBlogsScreen(),
    '/favoriteBlogs': (context) => const FavoriteBlogs(),
    '/admin_login': (context) => const AdminLoginPage(),
    '/admin_home': (context) => const AdminHome(),
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
