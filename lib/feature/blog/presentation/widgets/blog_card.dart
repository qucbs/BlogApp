import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/feature/blog/domain/entity/blog.dart';
import 'package:blog_app/routes.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(blogviewer, arguments: blog);
      },
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16).copyWith(bottom: 4),
        margin: const EdgeInsets.only(bottom: 16, top: 16, right: 8, left: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundsecodary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        blog.categories
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5),
                                child: Chip(
                                  label: Text(e),
                                  backgroundColor: AppColors.primary,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(blog.title, style: const TextStyle(fontSize: 20)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: Text('${calculateReadingTime(blog.content)} min'),
            ),
          ],
        ),
      ),
    );
  }
}
