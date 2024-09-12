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
      body: _body(),
    );
  }

  Widget _body() {
    return const Column(
      children: [
        Center(
          child: Text(
            "Category Screen",
            style: TextStyle(fontSize: 24),
          ),
        )
      ],
    );
  }
}
