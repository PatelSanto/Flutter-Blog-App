import 'package:blog_app/models/user.dart';
import 'package:blog_app/users/screens/home/category_blogs_screen.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/models/user_provider.dart';
import 'package:blog_app/users/screens/home/drawer_screen.dart';
import 'package:blog_app/users/widgets/appbar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataNotifierProvider);
    return Scaffold(
      drawer: const DrawerScreen(selectedIndex: 2),
      appBar: appBarWidget(context, userData, "All Categories"),
      body: _body(userData, context),
    );
  }

  Widget _body(UserData userData, BuildContext context) {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryBlogsScreen(categoryName: "Food blogs"),
                ),
              );
            },
            child: const Text("Food category blogs"),
          ),
        )
      ],
    );
  }
}
