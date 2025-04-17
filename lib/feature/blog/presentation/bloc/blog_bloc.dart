import 'dart:io';

import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/feature/blog/domain/entity/blog.dart';
import 'package:blog_app/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/feature/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({required UploadBlog uploadblog, required GetAllBlogs getAllBlogs})
    : _uploadBlog = uploadblog,
      _getAllBlogs = getAllBlogs,
      super(BlogInitial()) {
    on<BlogEvent>((event, emit) async {
      emit(BlogLoading());
    });
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
  }

  Future<void> _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    try {
      emit(BlogLoading());

      if (event.title.isEmpty ||
          event.content.isEmpty ||
          event.poster_id.isEmpty) {
        emit(BlogFailure('All fields are required'));
        return;
      }

      final result = await _uploadBlog(
        UploadBlogParams(
          title: event.title,
          content: event.content,
          poster_id: event.poster_id,
          categories: event.categories,
          image: event.image,
          edited_at:
              DateTime.now()
                  .toIso8601String(), // Ensure edited_at is passed correctly
        ),
      );

      result.fold(
        (failure) => emit(BlogFailure(failure.message)),
        (_) => emit(BlogUploadSuccess()),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }

  void _onFetchAllBlogs(
    BlogFetchAllBlogs event,
    Emitter<BlogState> emit,
  ) async {
    try {
      final result = await _getAllBlogs(Noparams());

      result.fold(
        (failure) => emit(BlogFailure(failure.message)),
        (success) => emit(BlogDisplaySuccess(success)),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }
}
