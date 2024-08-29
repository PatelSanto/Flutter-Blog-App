import 'package:flutter/material.dart';
import 'package:flutter_blog_app/constants/constants.dart';
import 'package:flutter_blog_app/users/services/auth_services.dart';
// import 'package:flutter_blog_app/users/services/database_services.dart';
// import 'package:flutter_blog_app/users/services/media_services.dart';
// import 'package:flutter_blog_app/users/services/storage_services.dart';
import 'package:get_it/get_it.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isLoadingCheckLogin)
              ? const CircularProgressIndicator.adaptive()
              : _loginSignupForm(),
        ],
      ),
    );
  }

  // Widget _signupText() {
  //   return const Text.rich(
  //     TextSpan(
  //       children: [
  //         TextSpan(
  //           text: "Get Started...\n\n",
  //           style: TextStyle(fontSize: 18),
  //         ),
  //         TextSpan(
  //           text: "Publish Your Passion in you own way...",
  //           style: TextStyle(
  //             fontSize: 30,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _loginSignupForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // name field
            const SizedBox(height: 30),
            _nameField(),
            //email field
            _emailField(),
            //password field
            _passwordField(),
            //confirm password field
            _confirmPasswordField(),
            //submit button
            //already have an account?
            //sign up with google button
          ],
        ),
      ),
    );
  }

  Widget _nameField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: name,
        decoration: const InputDecoration(
          labelText: 'Full Name',
          hintText: "Enter your name",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          formValidation();
        },
        validator: (value) {
          RegExp nameRegExp = Constants.nameValidationRegex;
          if (value!.isEmpty) {
            return 'Please enter Name';
          } else if (!nameRegExp.hasMatch(value)) {
            return 'Enter valid name, i.e. John Smith';
          }
          return null;
        },
      ),
    );
  }

  Widget _emailField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: email,
        decoration: const InputDecoration(
          labelText: 'Email',
          hintText: "Enter your email",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          formValidation();
        },
        validator: (value) {
          RegExp emailRegExp = Constants.emailValidationRegex;
          if (value!.isEmpty) {
            return 'Please enter Email';
          } else if (!emailRegExp.hasMatch(value)) {
            return 'Enter valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: password,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password',
          hintText: "Enter your password",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          formValidation();
        },
        validator: (value) {
          RegExp passwordRegExp = Constants.passwordValidationRegex;
          if (value!.isEmpty) {
            return 'Please enter Password';
          } else if (!passwordRegExp.hasMatch(value)) {
            return 'Password should be at least 8 characters long \nand contain at least one uppercase letter, \none lowercase letter, \none number, \nand one special character';
          }
          return null;
        },
      ),
    );
  }

  Widget _confirmPasswordField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: rePassword,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Confirm Password',
          hintText: "Confirm your password",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          formValidation();
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please confirm Password';
          } else if (value != password.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }
}
