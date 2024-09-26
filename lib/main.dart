import 'package:blog_app/header.dart';
import 'package:blog_app/users/screens/splash_screen/splash_screen.dart';

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
    '/splash': (context) => const SplashScreen(),
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
      // home: _authService.checkLogin(),
      home: const SplashScreen(),
    );
  }
}
