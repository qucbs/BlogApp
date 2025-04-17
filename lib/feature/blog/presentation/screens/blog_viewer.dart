import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/feature/blog/domain/entity/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerScreen extends StatelessWidget {
  final Blog blog;
  const BlogViewerScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${blog.posterName}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text('${blog.edited_at}.  ${calculateReadingTime(blog.content)} min'),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.image_url),
                ),
                const SizedBox(height: 20),
                Text(blog.content, style: TextStyle(fontSize: 16, height: 2),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
