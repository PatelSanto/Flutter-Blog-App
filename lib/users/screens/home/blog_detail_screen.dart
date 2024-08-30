// blog_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogDetailScreen extends StatelessWidget {
  final String blogId;

  BlogDetailScreen({required this.blogId});

  @override
  Widget build(BuildContext context) {
    final DocumentReference blogRef =
        FirebaseFirestore.instance.collection('blogs').doc(blogId);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: blogRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final blogData = snapshot.data?.data() as Map<String, dynamic>?;

          if (blogData == null) {
            return const Center(child: Text('Blog not found.'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(blogData['imageUrl'] ?? ''),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(blogData['title'] ?? '',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('By ${blogData['author'] ?? ''}'),
                      const SizedBox(height: 16),
                      Text(blogData['content'] ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
