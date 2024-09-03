// blog_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'comment_section.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_blog_app/main.dart';
import 'package:flutter/services.dart' show rootBundle;

class BlogDetailScreen extends StatelessWidget {
  final String blogId;

  BlogDetailScreen({Key? key, required this.blogId}) : super(key: key);

  final CollectionReference _blogsCollection =
      FirebaseFirestore.instance.collection('blogs');

  // Function to generate and download PDF
  Future<void> _downloadBlogAsPDF(String title, String content) async {
    final pdf = pw.Document();

    // Load custom font
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);
    final boldFontData = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    final ttfBold = pw.Font.ttf(boldFontData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title,
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text(content, style: const pw.TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );

    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/$title.pdf");

      await file.writeAsBytes(await pdf.save());

      print("Blog downloaded to ${file.path}");
      // final directory = await getExternalStorageDirectory();
      // final filePath = '${directory!.path}/$title.pdf';
      // final file = File(filePath);

      // await file.writeAsBytes(await pdf.save());

      // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      //   SnackBar(content: Text('PDF downloaded to $filePath')),
      // );
    } else {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Storage permission not granted.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _blogsCollection.doc(blogId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Blog not found.'));
          }

          final blog = snapshot.data!.data() as Map<String, dynamic>;
          final String title = blog['title'] ?? 'No Title';
          final String content = blog['content'] ?? 'No Content';
          final String author = blog['author'] ?? 'Unknown Author';
          final String imageUrl = blog['imageUrl'] ?? '';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageUrl.isNotEmpty
                      ? Image.network(imageUrl)
                      : const Placeholder(fallbackHeight: 200),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text('By $author',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 20),
                  Text(content, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 20),

                  // Download button for PDF
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.blue[100]),
                    ),
                    onPressed: () => _downloadBlogAsPDF(title, content),
                    icon: const Icon(Icons.download),
                    label: const Text('Download Blog as PDF'),
                  ),
                  const SizedBox(height: 20),

                  // Comments Section
                  CommentSection(blogId: blogId),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
