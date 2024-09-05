import 'package:flutter/material.dart';
import 'package:flutter_blog_app/users/screens/home/drawer_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(selectedIndex: 2),
      appBar: AppBar(
        title: const Text(
          'Blogs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
            iconSize: 30,
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: GestureDetector(
              onTap: () {
                //* open profile screen
                Navigator.pushNamed(context, "/profile");
              },
              child: CircleAvatar(
                radius: 25,
                backgroundImage: const AssetImage("assets/images/profile.jpg"),
                backgroundColor: Colors.grey[200],
              ),
            ),
          ),
        ],
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Text(
              "Category Screen",
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}
