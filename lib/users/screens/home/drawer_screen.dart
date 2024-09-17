import 'dart:ui';

import 'package:blog_app/admin/admin_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/users/screens/auth/user%20profile%20screens/myblogs_screen.dart';
import 'package:blog_app/users/screens/home/category%20screens/categories_screen.dart';
import 'package:blog_app/users/screens/home/home_screen.dart';

import '../../../constants/constants.dart';

class DrawerScreen extends StatefulWidget {
  final int selectedIndex; // Accept a selected index

  const DrawerScreen({super.key, this.selectedIndex = 0});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // Initialize the selected index
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Drawer(
        backgroundColor: Constants.drawerBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              Image.asset(
                "assets/images/techny-blog-article-on-the-tablet.png",
                height: 200,
              ),
              const SizedBox(height: 20),
              drawerTile(
                title: 'Home',
                icon: CupertinoIcons.home,
                isSelected: _selectedIndex == 0, // Highlight if selected
                onTap: () {
                  _navigateToPage(context, 0, const HomeScreen());
                },
              ),
              drawerTile(
                title: 'My Blogs',
                icon: CupertinoIcons.news,
                isSelected: _selectedIndex == 1, // Highlight if selected
                onTap: () {
                  _navigateToPage(context, 1, const MyBlogsScreen());
                },
              ),
              drawerTile(
                title: 'Blog Categories',
                icon: Icons.category_outlined,
                isSelected: _selectedIndex == 2,
                onTap: () {
                  _navigateToPage(context, 2, CategoryScreen());
                },
              ),
              drawerTile(
                title: 'Admin',
                icon: Icons.admin_panel_settings,
                isSelected: _selectedIndex == 4, // Highlight if selected
                onTap: () {
                  _navigateToPage(context, 4, const AdminLoginPage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index, Widget page) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page, // Navigate to the selected page
      ),
    );
  }

  Widget drawerTile(
      {required IconData icon,
      required String title,
      bool isSelected = false,
      VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white
            : Colors.transparent, // Change bg color based on selection
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(50),
        ),
      ),
      child: ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(50),
          ),
        ),
        leading: Icon(
          icon,
          color: isSelected
              ? Constants.primaryColor
              : Colors.white, // Change icon color based on selection
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Constants.primaryColor
                : Colors.white, // Change text color based on selection
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
