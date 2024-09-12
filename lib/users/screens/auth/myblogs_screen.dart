import 'package:blog_app/users/screens/home/create_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/models/user_provider.dart';
import 'package:blog_app/users/screens/home/blog_detail_screen.dart';
import 'package:blog_app/users/screens/home/drawer_screen.dart';
import 'package:blog_app/users/services/database_services.dart';
import 'package:blog_app/users/widgets/appbar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyBlogsScreen extends ConsumerStatefulWidget {
  const MyBlogsScreen({super.key});

  @override
  ConsumerState<MyBlogsScreen> createState() => _MyBlogsScreenState();
}

class _MyBlogsScreenState extends ConsumerState<MyBlogsScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataNotifierProvider);
    return Scaffold(
      drawer: const DrawerScreen(selectedIndex: 1),
      appBar: appBarWidget(context, userData, "My Blogs"),
      body: _body(),
      floatingActionButton: _createBlogButton(),
    );
  }

  Widget _body() {
    final userData = ref.watch(userDataNotifierProvider);
    return StreamBuilder(
      stream: getUserBlogs(userData.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading blogs."));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Opacity(
            opacity: 0.6,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    "assets/images/3d-casual-life-question-mark-icon-1.png",
                    width: 200,
                    // color: ,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('No blogs found'),
                ],
              ),
            ),
          );
        }

        final blogs = snapshot.data;
        return ListView.builder(
          itemCount: blogs.length,
          itemBuilder: (BuildContext context, int index) {
            final blog = blogs[index];
            return Dismissible(
              key: ValueKey(blogs[index]),
              confirmDismiss: (direction) {
                return deleteBlog(context, blog.id);
              },
              background: slideRightBackground(),
              direction: DismissDirection.endToStart,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: blog.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(blog.imageUrl,
                              width: 60, height: 100, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.image, size: 50, color: Colors.grey),
                  title: Text(
                    blog.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('By ${blog.author}'),
                      Text('${blog.readingTime} Min Read'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${blog.views} Views'),
                      Text('${blog.comments} Comments'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetailScreen(blog: blog),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget slideRightBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.red[400],
      child: const Row(
        children: [
          SizedBox(width: 20),
          Text(
            "Delete this Blog... ",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _createBlogButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateBlogScreen()),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
