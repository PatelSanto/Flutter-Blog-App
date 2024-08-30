import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blog_app/constants/constants.dart';
import 'package:flutter_blog_app/models/user.dart';
import 'package:flutter_blog_app/users/services/auth_services.dart';
import 'package:flutter_blog_app/users/services/database_services.dart';
import 'package:flutter_blog_app/users/services/media_services.dart';
import 'package:flutter_blog_app/users/services/storage_services.dart';
import 'package:flutter_blog_app/users/widgets/auth_widgets.dart';
import 'package:flutter_blog_app/users/widgets/snackbar.dart';
import 'package:get_it/get_it.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late AuthService _authService;
  late MediaServices _mediaServices;
  late StorageService _storageServices;
  late DatabaseService _databaseServices;

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoginPage = false;
  bool formvalidation = false;
  File? selectedImage;

  // bool isLoadingCheckLogin = false;
  bool isLoadingLogin = false;
  bool isLoadingSignup = false;
  // bool isLoadingGoogle = false;

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();
    _mediaServices = GetIt.instance.get<MediaServices>();
    _storageServices = GetIt.instance.get<StorageService>();
    _databaseServices = GetIt.instance.get<DatabaseService>();

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
      // resizeToAvoidBottomInset: false,
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SignupForm(),
          ],
        ),
      ),
    );
  }

  Widget _SignupForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // image picker
          _signupPageImagePicker(),
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
          _signupButton(),
          //already have an account?
          //sign up with google button
        ],
      ),
    );
  }

  Widget _signupPageImagePicker() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaServices.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        // decoration: BoxDecoration(border: Border.all()),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: MediaQuery.of(context).size.width * 0.17,
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.16,
            backgroundImage: (selectedImage != null)
                ? FileImage(selectedImage!)
                : (const AssetImage("assets/images/profile.jpg")
                    as ImageProvider),
          ),
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

  Widget _signupButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: (isLoadingSignup)
          ? const CircularProgressIndicator.adaptive()
          : authButton(
              buttonName: "Sign up",
              ontap: () {
                _signupOnPressed();
              },
            ),
    );
  }

  Future<void> _signupOnPressed() async {
    print("signup button clicked");

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoadingSignup = true;
      });

      try {
        bool result = await _authService.signup(email.text, password.text);
        if (result) {
          String? pfpicUrl = "";
          if (selectedImage != null) {
            pfpicUrl = await _storageServices.uploadUserPfpic(
              file: selectedImage!,
              uid: _authService.user!.uid,
            );
            print("--------------Download Url: $pfpicUrl :--------------");
          }
          await _databaseServices
              .createUserProfile(
            userProfile: UserProfile(
              uid: _authService.user!.uid,
              name: name.text,
              pfpURL: pfpicUrl,
              email: email.text,
            ),
          )
              .then((value) {
            snackbarToast(
              context: context,
              title: "Login successfully",
              icon: Icons.login,
            );
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, "/home");
          }).catchError((error) {
            snackbarToast(
              context: context,
              title: "Failed to Signup",
              icon: Icons.error,
            );
          });
        }
        setState(() {
          isLoadingSignup = result;
        });
      } catch (e) {
        snackbarToast(
          context: context,
          title: "Unable to Register User!",
          icon: Icons.error_outline,
        );
        print("Error ai: $e");
      }
    } else {
      snackbarToast(
        context: context,
        title: "Please enter valid details...",
        icon: Icons.error_outline,
      );
    }
  }
}
