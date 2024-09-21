import 'package:blog_app/models/user_provider.dart';
import 'package:blog_app/users/screens/home/blog%20screens/blog_detail_screen.dart';
import 'package:blog_app/users/services/database_services.dart';
import 'package:blog_app/users/widgets/blog_tile.dart';
import 'package:blog_app/users/widgets/other_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteBlogs extends ConsumerStatefulWidget {
  const FavoriteBlogs({super.key});

  @override
  ConsumerState<FavoriteBlogs> createState() => _FavoriteBlogsState();
}

class _FavoriteBlogsState extends ConsumerState<FavoriteBlogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Blogs"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    final userData = ref.watch(userDataNotifierProvider);
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: getFavoriteBlogs(userData),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Error loading blogs."));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return noBlogFoundWidget();
              }

              final blogs = snapshot.data;
              return ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (BuildContext context, int index) {
                  final blog = blogs[index];
                  return blogTile(
                    leadingImage: blog.imageUrl,
                    title: blog.title,
                    author: blog.author,
                    readingTime: blog.readingTime,
                    views: blog.views,
                    comments: blog.comments,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetailScreen(blog: blog),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
