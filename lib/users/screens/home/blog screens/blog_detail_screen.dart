import 'package:intl/intl.dart';

import 'comment_section.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'package:blog_app/header.dart';

class BlogDetailScreen extends ConsumerStatefulWidget {
  final Blog blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  ConsumerState<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends ConsumerState<BlogDetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _incrementViews();
    _updateCommentCount();
  }

  // Function to generate and download PDF
  Future<void> _downloadBlogAsPDF(BuildContext context) async {
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
            pw.Text(
              widget.blog.title,
              style: pw.TextStyle(font: ttfBold, fontSize: 24),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              widget.blog.content,
              style: pw.TextStyle(font: ttf),
            ),
          ],
        ),
      ),
    );

    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      // Get the Downloads directory
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDirectory = await getDownloadsDirectory();
      }

      final filePath = "${downloadsDirectory?.path}/${widget.blog.title}.pdf";

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Blog downloaded to $filePath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission not granted.')),
      );
    }
  }

  // Function to increment views only once per user
  Future<void> _incrementViews() async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      final blogRef =
          FirebaseFirestore.instance.collection('blogs').doc(widget.blog.id);

      // Check if the current user has already viewed the blog
      final blogSnapshot = await blogRef.get();
      final List<dynamic> viewedBy = blogSnapshot['viewedBy'] ?? [];

      if (!viewedBy.contains(currentUser.uid)) {
        // If the user hasn't viewed the blog, increment views and add the user ID to the list
        await blogRef.update({
          'views': FieldValue.increment(1),
          'viewedBy': FieldValue.arrayUnion(
              [currentUser.uid]), // Add user ID to viewedBy list
        });
      }
    }
  }

  // Function to update the comment count based on the actual number of comments
  Future<void> _updateCommentCount() async {
    final blogRef =
        FirebaseFirestore.instance.collection('blogs').doc(widget.blog.id);

    // Count the number of documents in the comments sub-collection
    final commentsSnapshot = await blogRef.collection('comments').get();
    final int commentCount = commentsSnapshot.size;

    // Update the 'comments' field in the main blog document
    await blogRef.update({
      'comments': commentCount,
    });

    setState(() {
      widget.blog.comments = commentCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (!userData.favoriteBlogs.contains(widget.blog.id)) {
                ref.read(userDataNotifierProvider.notifier).updateUserData(
                  favoriteBlogs: {...userData.favoriteBlogs, widget.blog.id},
                );
                setState(() {
                  isFavorite = true;
                });
                print("added to favorite blogs");
              } else {
                ref.read(userDataNotifierProvider.notifier).updateUserData(
                      favoriteBlogs:
                          userData.favoriteBlogs.remove(widget.blog.id)
                              ? userData.favoriteBlogs
                              : userData.favoriteBlogs,
                    );
                if (userData.favoriteBlogs.isEmpty) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/home",
                    (Route<dynamic> route) => false,
                  );
                }

                print("removed from favorite blogs");
                setState(() {
                  isFavorite = false;
                });
              }
            },
            icon: Icon(
              (checkIfFavorite())
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              size: 30,
              color: Colors.red[300],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.blog.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(widget.blog.imageUrl),
                  )
                : const Placeholder(fallbackHeight: 200),
            const SizedBox(height: 10),
            Text(
              widget.blog.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'By ${widget.blog.author}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 20),
            Text(widget.blog.content,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'At, ${formatTimestamp(widget.blog.timeStamp,format: "MMMM d, yyyy")}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            // Download button for PDF
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.lightBlue),
                  iconColor: WidgetStateProperty.all(Colors.white)),
              onPressed: () => _downloadBlogAsPDF(context),
              icon: const Icon(Icons.download),
              label: const Text(
                'Download Blog as PDF',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            CommentSection(blogId: widget.blog.id),
          ],
        ),
      ),
    );
  }

  checkIfFavorite() {
    // Implement logic to check if the blog is a favorite
    final userData = ref.watch(userDataNotifierProvider);
    setState(() {
      isFavorite = userData.favoriteBlogs.contains(widget.blog.id);
    });
    return isFavorite;
  }

  String formatTimestamp(Timestamp timestamp, {String format = 'yyyy-MM-dd'}) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat(format).format(dateTime);
  }
}
