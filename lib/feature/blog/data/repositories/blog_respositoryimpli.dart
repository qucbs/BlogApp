import 'dart:io';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_supabase_source.dart';
import 'package:blog_app/feature/blog/data/model/blog_model.dart';
import 'package:blog_app/feature/blog/domain/entity/blog.dart';
import 'package:blog_app/feature/blog/domain/repository/bloc_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryimpl implements BlogRepository {
  final BlogSupabaseSource blogSupabaseSource;
  BlogRepositoryimpl(this.blogSupabaseSource);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required List<String> categories,
    required String poster_id,
    required String edited_at,
  }) async {
    try {
      print('Debug: Title: $title');
      print('Debug: Content: $content');
      print('Debug: Poster ID: $poster_id');
      print('Debug: Categories: $categories');
      print('Debug: Image: $image');
      print('Debug: Edited At: $edited_at');

      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        title: title,
        content: content,
        image_url: '',
        categories: categories,
        edited_at: DateTime.now(), // Set edited_at to current time
        poster_id: poster_id,
      );

      final image_url = await blogSupabaseSource.uploadblogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copywith(image_url: image_url);

      final uploadedblog = await blogSupabaseSource.uploadBlog(blogModel);
      return right(uploadedblog);
    } catch (e) {
      return left(Failure('Unexpected error occurred: $e'));
    }
  }
}
