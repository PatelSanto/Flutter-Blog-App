import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/users/screens/home/category_screen.dart';
import 'package:flutter_blog_app/users/screens/home/home_screen.dart';

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
    return Drawer(
      backgroundColor: AppColors.drawerBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const Center(
              child: Text(
                'Blogs',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
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
                _navigateToPage(context, 1, const HomeScreen());
              },
            ),
            drawerTile(
              title: 'Category',
              icon: Icons.category_outlined,
              isSelected: _selectedIndex == 2,
              onTap: () {
                _navigateToPage(context, 2, const CategoryScreen());
              },
            ),
            drawerTile(
              title: 'Setting',
              icon: CupertinoIcons.settings,
              isSelected: _selectedIndex == 3, // Highlight if selected
              onTap: () {
                _navigateToPage(context, 3, const CategoryScreen());
              },
            ),
            drawerTile(
              title: 'Help',
              icon: Icons.help_outline,
              isSelected: _selectedIndex == 4, // Highlight if selected
              onTap: () {
                _navigateToPage(context, 4, const CategoryScreen());
              },
            ),
          ],
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
              ? AppColors.drawerBackground
              : Colors.white, // Change icon color based on selection
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppColors.drawerBackground
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
