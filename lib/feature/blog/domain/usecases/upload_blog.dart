import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/feature/blog/domain/entity/blog.dart';
import 'package:blog_app/feature/blog/domain/repository/bloc_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog , UploadBlogParams>{
  final BlogRepository blogRepository;
  const UploadBlog(this.blogRepository);
  
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      categories: params.categories,
      poster_id: params.poster_id,
      edited_at: DateTime.now().toIso8601String(), // Ensure edited_at is passed correctly
    );
  }
}

class UploadBlogParams {
  final File image;
  final String title;
  final String content;
  final List<String> categories;
  final String poster_id;
  final String edited_at; // Added edited_at field

  const UploadBlogParams({
    required this.image,
    required this.title,
    required this.content,
    required this.categories,
    required this.poster_id,
    required this.edited_at,
  });
}