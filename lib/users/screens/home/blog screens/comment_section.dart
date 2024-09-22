import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentSection extends StatefulWidget {
  final String blogId;

  const CommentSection({super.key, required this.blogId});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();

  // Function to add a comment and then update the comment count
  Future<void> _addComment(String commentText) async {
    if (commentText.isEmpty) return;

    try {
      // Add comment to the 'comments' sub-collection inside the blog document
      await FirebaseFirestore.instance
          .collection('blogs')
          .doc(widget.blogId)
          .collection('comments')
          .add({
        'comment': commentText,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the comment input field
      _commentController.clear();

      // Call the parent widget to update the comment count
      await _updateCommentCount();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post comment: $e')),
      );
    }
  }

  // Function to update the comment count in the main blog document
  Future<void> _updateCommentCount() async {
    final blogRef =
        FirebaseFirestore.instance.collection('blogs').doc(widget.blogId);

    // Count the number of documents in the 'comments' sub-collection inside the specific blog
    final commentsSnapshot = await blogRef.collection('comments').get();

    final int commentCount = commentsSnapshot.size;

    // Update the 'comments' field in the main blog document
    await blogRef.update({
      'comments': commentCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comment input field
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _addComment(_commentController.text);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Display comments
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('blogs')
              .doc(widget.blogId)
              .collection('comments')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No comments yet. Be the first to comment!');
            }

            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(data['comment'] ?? ''),
                    subtitle:
                        Text('Posted by ${data['userId'] ?? "Anonymous"}'),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
