import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blog.dart';
import '../users/screens/home/blog screens/blog_detail_screen.dart';

class ManageBlogsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ManageBlogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Manage Blogs',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 25),
        ),
        backgroundColor: Colors.purple[100],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('blogs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No blogs found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              var doc = snapshot.data?.docs[index];
              var data = doc?.data() as Map<String, dynamic>;

              Blog blog = Blog(
                id: doc!.id,
                title: data['title'],
                content: data['content'],
                imageUrl: data['imageUrl'],
                author: data['author'],
                comments: data['comments'] ?? 0,
                authorUid: data['authorUid'] ?? "Unknown author",
                readingTime: data['readingTime'] ?? 5,
              );

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(blog.title),
                  subtitle: Text('Posted by: ${blog.author}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      await _firestore.collection('blogs').doc(doc.id).delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Blog deleted.')),
                      );
                    },
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
              );
            },
          );
        },
      ),
    );
  }
}
