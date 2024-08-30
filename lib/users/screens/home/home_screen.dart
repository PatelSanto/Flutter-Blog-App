// blog_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_blog_screen.dart';
import 'blog_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _blogs =
      FirebaseFirestore.instance.collection('blogs');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Implement the menu functionality (e.g., open a drawer or show a menu)
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter action if needed
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                // Implement profile action (e.g., open profile screen)
              },
              child: CircleAvatar(
                backgroundImage: const NetworkImage(
                  'https://via.placeholder.com/150', // Replace with the user's profile image URL
                ),
                backgroundColor: Colors.grey[200],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Blogs',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_alt_outlined),
                  onPressed: () {
                    // Implement filter functionality
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _blogs.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final blogs = snapshot.data?.docs ?? [];

                // Filter blogs based on search query
                final filteredBlogs = blogs.where((blog) {
                  final title = blog['title']?.toString().toLowerCase() ?? '';
                  return title.contains(_searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredBlogs.length,
                  itemBuilder: (context, index) {
                    final blog = filteredBlogs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: blog['imageUrl'] != null &&
                                blog['imageUrl'].isNotEmpty
                            ? Image.network(blog['imageUrl'],
                                width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.image,
                                size: 50, color: Colors.grey),
                        title: Text(blog['title'] ?? 'No Title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('By ${blog['author'] ?? 'Unknown Author'}'),
                            Text('${blog['readingTime']} Mins Read'),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Text('${blog['views']} Views'),
                            Text('${blog['comments']} Comments'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlogDetailScreen(blogId: blog.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateBlogScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
