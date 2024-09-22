import 'package:flutter/material.dart';
import 'package:blog_app/users/widgets/blog_tile.dart';
import 'package:blog_app/users/widgets/other_widgets.dart';
import 'package:blog_app/users/services/database_services.dart';
import 'package:blog_app/users/screens/home/blog%20screens/blog_detail_screen.dart';

class CategoryBlogsScreen extends StatefulWidget {
  const CategoryBlogsScreen({super.key, required this.categoryName});
  final String categoryName;

  @override
  State<CategoryBlogsScreen> createState() => _CategoryBlogsScreenState();
}

class _CategoryBlogsScreenState extends State<CategoryBlogsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 46, 75, 150),
        foregroundColor: Colors.white,
        title: Text(widget.categoryName),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: getCategoryBlogs(widget.categoryName),
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
