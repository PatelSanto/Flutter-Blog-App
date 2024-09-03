import 'package:flutter/material.dart';
import 'package:flutter_blog_app/users/services/auth_services.dart';
import 'package:get_it/get_it.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late AuthService _authService;

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 46, 75, 150),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Container(
                height: s.height * 0.15,
                alignment: const Alignment(0.3, 0.9),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(
                      "assets/images/blank-profile-picture.webp",
                    ),
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: s.height * 0.02,
            ),
            const Text(
              'Full Name',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 46, 75, 150),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '@Username',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: s.height * 0.03,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile_edit_page');
              },
              child: Container(
                height: s.height * 0.05,
                width: s.width * 0.4,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 46, 75, 150),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: s.height * 0.03,
            ),
            const Divider(),
            ListTile(
              onTap: () {},
              title: const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: const Icon(Icons.settings_outlined),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                'My Orders',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: const Icon(Icons.local_mall_outlined),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                'Address',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: const Icon(Icons.location_on_outlined),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {},
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
            const Divider(),
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
      ),
    );
  }
}
