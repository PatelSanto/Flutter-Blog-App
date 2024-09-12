import 'package:flutter/material.dart';
import 'package:blog_app/models/user.dart';

PreferredSizeWidget appBarWidget(BuildContext context, UserData userData, String screenName) {
  return AppBar(
    title: Text(
      screenName,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
            // Open profile screen
            Navigator.pushNamed(context, "/profile");
          },
          child: ClipOval(
            child: Image.network(
              "${userData.pfpURL}",
              height: 50,
              width: 50,
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
      ),
    ],
  );
}
