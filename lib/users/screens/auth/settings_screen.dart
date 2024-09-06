import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/user_provider.dart';
import 'package:flutter_blog_app/users/screens/home/drawer_screen.dart';
import 'package:flutter_blog_app/users/widgets/appbar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataNotifierProvider);
    return Scaffold(
      drawer: const DrawerScreen(selectedIndex: 2),
      appBar: appBarWidget(context, userData, "Settings"),
      body: _body(),
    );
  }

  Widget _body() {
    return const Column(
      children: [
        Center(
          child: Text(
            "Settings Screen",
            style: TextStyle(fontSize: 24),
          ),
        )
      ],
    );
  }
}