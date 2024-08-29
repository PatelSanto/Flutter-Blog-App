import 'package:flutter/material.dart';
import 'package:flutter_blog_app/users/services/auth_services.dart';
// import 'package:flutter_blog_app/users/services/database_services.dart';
// import 'package:flutter_blog_app/users/services/media_services.dart';
// import 'package:flutter_blog_app/users/services/storage_services.dart';
import 'package:get_it/get_it.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  late AuthService _authService;
  // late MediaServices _mediaServices;
  // late StorageService _storageServices;
  // late DatabaseService _databaseServices;

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoginPage = false;
  bool formvalidation = false;

  bool isLoadingCheckLogin = false;
  // bool isLoadingLogin = false;
  // bool isLoadingSignup = false;
  // bool isLoadingGoogle = false;

  @override
  void initState() {
    // _authService = Get.find<AuthService>();
    _authService = GetIt.instance.get<AuthService>();
    // _mediaServices = GetIt.instance.get<MediaServices>();
    // _storageServices = GetIt.instance.get<StorageService>();
    // _databaseServices = GetIt.instance.get<DatabaseService>();

    // _checkLogin();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    name.dispose();
    email.dispose();
    password.dispose();
    rePassword.dispose();
    super.dispose();
  }

  void formValidation() {
    if (_formKey.currentState!.validate()) {
      formvalidation = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _signupText(),
          (isLoadingCheckLogin)
              ? const CircularProgressIndicator.adaptive()
              : _loginSignupForm(),
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

  Widget _loginSignupForm() {
    return Form(
      key: _formKey,
      child: const SingleChildScrollView(
        child: Column(
          
        ),
      ),
    );
  }
}
