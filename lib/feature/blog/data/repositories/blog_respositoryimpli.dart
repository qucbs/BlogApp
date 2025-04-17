import 'dart:io';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_local_datasource.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_supabase_source.dart';
import 'package:blog_app/feature/blog/data/model/blog_model.dart';
import 'package:blog_app/feature/blog/domain/entity/blog.dart';
import 'package:blog_app/feature/blog/domain/repository/bloc_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryimpl implements BlogRepository {
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  final BlogSupabaseSource blogSupabaseSource;
  BlogRepositoryimpl(this.blogSupabaseSource, this.blogLocalDataSource, this.connectionChecker);

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
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
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

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogSupabaseSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
