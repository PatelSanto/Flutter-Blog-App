import 'package:blog_app/header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AuthService _authService;
  Color forgroundColor = Constants.backgroundColor2;

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 46, 75, 150),
        foregroundColor: Colors.white,
        title: const Text("Settings"),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              snackbarToast(
                  context: context,
                  title: "This function is not available yet.",
                  icon: Icons.error_outline);
            },
            title: Text(
              'Change Password',
              style: TextStyle(
                color: forgroundColor,
              ),
            ),
            leading: Icon(
              Icons.lock_outline_rounded,
              color: forgroundColor,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: forgroundColor,
            ),
          ),
          ListTile(
            onTap: () {},
            title: Text(
              'Help & Support',
              style: TextStyle(
                color: forgroundColor,
              ),
            ),
            leading: Icon(
              Icons.help_outline,
              color: forgroundColor,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: forgroundColor,
            ),
          ),
          ListTile(
            onTap: () {
              _authService.logoutDilog(context);
            },
            title: Text(
              'Logout',
              style: TextStyle(
                color: forgroundColor,
              ),
            ),
            leading: Icon(
              Icons.logout,
              color: forgroundColor,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: forgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
