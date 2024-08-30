import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog_model.dart';

class BlogTile extends StatelessWidget {
  final Blog blog;

  BlogTile({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.network(
            blog.imageUrl, // URL for the blog image
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          // Use Expanded to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.date, // Blog date
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 4.0), // Spacing between date and title
              Text(
                blog.title, // Blog title
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                overflow:
                    TextOverflow.ellipsis, // Prevent overflow with ellipsis
                maxLines: 2, // Limit the title to 2 lines
              ),
            ],
          ),
        ),
      ],
    );
  }
}
