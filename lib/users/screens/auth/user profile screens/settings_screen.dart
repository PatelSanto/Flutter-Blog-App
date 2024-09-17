import 'package:blog_app/users/services/auth_services.dart';
import 'package:blog_app/users/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AuthService _authService;

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            title: const Text(
              'Change Password',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: const Icon(Icons.lock_outline_rounded),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.black,
            ),
          ),
          ListTile(
            onTap: () {},
            title: const Text(
              'Help & Support',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: const Icon(Icons.help_outline),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.black,
            ),
          ),
          ListTile(
            onTap: () {
              _authService.logoutDilog(context);
            },
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: const Icon(Icons.logout),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
