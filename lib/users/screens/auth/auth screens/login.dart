import 'package:blog_app/header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthService _authService;
  bool isLoadingLogin = false;
  bool formvalidation = false;

  final email = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
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
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _loginForm(context),
          ],
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _loginImage(),
          _emailField(),
          _passwordField(),
          _loginButton(context),
        ],
      ),
    );
  }

  Widget _loginImage() {
    return Image.asset(
      'assets/images/login2.png',
      fit: BoxFit.cover,
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
          if (value!.isEmpty) {
            return 'Please enter Password';
          }
          return null;
        },
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: (isLoadingLogin)
          ? const CircularProgressIndicator.adaptive()
          : authButton(
              buttonName: "Login",
              ontap: () {
                _loginOnPressed(context);
              },
            ),
    );
  }

  Future<void> _loginOnPressed(BuildContext context) async {
    print("login button clicked");
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoadingLogin = true;
      });

      try {
        final result = await _authService.login(email.text, password.text);
        setState(() {
          isLoadingLogin = result;
        });
        if (result) {
          snackbarToast(
            context: context,
            title: "Login successfully",
            icon: Icons.login,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/home",
            (Route<dynamic> route) =>
                false, // This removes all the previous routes
          );
        } else {
          snackbarToast(
            context: context,
            title: "Invalid credentials!",
            icon: Icons.error_outline,
          );
        }
      } catch (e) {
        snackbarToast(
          context: context,
          title: "Unable to Login User!",
          icon: Icons.error_outline,
        );
        print("error: $e");
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
