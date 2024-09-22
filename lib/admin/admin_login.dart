import 'package:blog_app/users/services/auth_services.dart';
import 'package:blog_app/users/widgets/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        children: const [Menu(), Body()],
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     _menuItem(title: 'Home'),
          //     _menuItem(title: 'About us'),
          //     _menuItem(title: 'Contact us'),
          //     _menuItem(title: 'Help'),
          //   ],
          // ),
          Row(
            children: [
              _menuItem(title: 'Sign In', isActive: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    String title = 'Title Menu',
    bool isActive = false,
    Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 75),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.deepPurple : Colors.grey,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              isActive
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  late AuthService _authService;
  bool isLoadingLogin = false;

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();
    super.initState();
  }

  List<String> passwordErrors = [];
  // Regular expressions for validation
  final RegExp emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final RegExp uppercaseRegExp = RegExp(r'[A-Z]');
  final RegExp lowercaseRegExp = RegExp(r'[a-z]');
  final RegExp numberRegExp = RegExp(r'[0-9]');
  final RegExp specialCharRegExp = RegExp(r'[@#_]');

  // Validate the password and generate error messages
  void validatePassword(String password) {
    passwordErrors.clear();

    if (password.isEmpty) {
      passwordErrors.add('Password cannot be empty.');
    } else {
      if (password.length < 8) {
        passwordErrors.add('Password must be at least 8 characters long.');
      }
      if (!uppercaseRegExp.hasMatch(password)) {
        passwordErrors
            .add('Password must contain at least one uppercase letter (A-Z).');
      }
      if (!lowercaseRegExp.hasMatch(password)) {
        passwordErrors
            .add('Password must contain at least one lowercase letter (a-z).');
      }
      if (!numberRegExp.hasMatch(password)) {
        passwordErrors.add('Password must contain at least one number (0-9).');
      }
      if (!specialCharRegExp.hasMatch(password)) {
        passwordErrors.add(
            'Password must contain at least one special character (@, #, _).');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * .9,
      // width: (size.width < 1300) ? 360 : size.width,
      child: ListView(
        scrollDirection: (size.width < 1300) ? Axis.vertical : Axis.horizontal,
        children: [
          SizedBox(
            width: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to the \nAdmin Panel',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/illustration-2.png',
                  width: 250,
                ),
              ],
            ),
          ),
          (size.width < 1300)
              ? const SizedBox()
              : Image.asset(
                  'assets/images/illustration-1.png',
                  width: 250,
                ),
                SizedBox(width: size.width * 0.05,),
          SizedBox(
            width: 360,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: (size.width < 1300)
                    ? 0
                    : MediaQuery.of(context).size.height / 6,
              ),
              child: _formLogin(context),
            ),
          )
        ],
      ),
    );
  }

  Widget _formLogin(BuildContext context) {
    return Form(
      key: _formKey, // Add the form key for validation
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Enter email or Phone number',
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            // Validate the email
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter your email';
            //   } else if (!emailRegExp.hasMatch(value)) {
            //     return 'Enter a valid email address';
            //   }
            //   return null;
            // },
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              hintText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            // Validate password on input
            // onChanged: (value) {
            //   setState(() {
            //     validatePassword(value);
            //   });
            // },
          ),
          // Display password errors
          // if (passwordErrors.isNotEmpty)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 10),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: passwordErrors
          //           .map((error) => Text(
          //                 error,
          //                 style:
          //                     const TextStyle(color: Colors.red, fontSize: 12),
          //               ))
          //           .toList(),
          //     ),
          //   ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.shade100,
                  spreadRadius: 10,
                  blurRadius: 20,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // if (_formKey.currentState!.validate() &&
                //     passwordErrors.isEmpty) {
                //   // Navigate to HomePage on successful validation

                // }
                _loginOnPressed(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: (isLoadingLogin)
                      ? const CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        )
                      : const Text("Sign In"),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  // Open forgot password screen
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Divider(
          //         color: Colors.grey[300],
          //         height: 50,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Future<void> _loginOnPressed(BuildContext context) async {
    print("login button clicked");
    setState(() {
      isLoadingLogin = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        final result = await _authService.login(
            emailController.text, passwordController.text);

        if (result) {
          snackbarToast(
            context: context,
            title: "Login successfully",
            icon: Icons.login,
          );
          Navigator.pushReplacementNamed(
            context,
            "/admin_home",
          );
          setState(() {
            isLoadingLogin = false;
          });
        } else {
          snackbarToast(
            context: context,
            title: "Invalid credentials!",
            icon: Icons.error_outline,
          );
          setState(() {
            isLoadingLogin = false;
          });
        }
      } catch (e) {
        snackbarToast(
          context: context,
          title: "Unable to Login User!",
          icon: Icons.error_outline,
        );
        setState(() {
          isLoadingLogin = false;
        });
        print("error: $e");
      }
    } else {
      snackbarToast(
        context: context,
        title: "Please enter valid details...",
        icon: Icons.error_outline,
      );
      setState(() {
        isLoadingLogin = false;
      });
    }
  }
}
