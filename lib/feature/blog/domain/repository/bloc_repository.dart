import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/feature/blog/domain/entity/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required List<String> categories,
    required String poster_id,
    required String edited_at,
  });

  Future <Either<Failure, List<Blog>>> getAllBlogs();
}
