import 'package:flutter/material.dart';
import 'package:blog_app/models/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.sizeOf(context);
    final userData = ref.watch(userDataNotifierProvider);

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
              child: ClipOval(
                child: Image.network(
                  "${userData.pfpURL}",
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return const CircularProgressIndicator.adaptive();
                    } else {
                      return child;
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      color: Colors.black12,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: s.height * 0.02,
            ),
            Text(
              "${userData.name}",
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 46, 75, 150),
                fontWeight: FontWeight.bold,
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
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/myblogs",
                  (Route<dynamic> route) => false,
                );
              },
              title: const Text(
                'My Blogs',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: const Icon(
                Icons.my_library_books_outlined,
                color: Color.fromARGB(255, 46, 75, 150),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/favoriteBlogs",
                );
              },
              title: const Text(
                'Favorite Blogs',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: Icon(
                Icons.favorite_rounded,
                color: Colors.red[400],
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
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
          ],
        ),
      ),
    );
  }
}
