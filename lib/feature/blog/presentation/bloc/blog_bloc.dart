import 'dart:io';

import 'package:blog_app/feature/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;

  BlogBloc({required this.uploadBlog}) : super(BlogInitial()) {
    on<BlogUpload>(_onBlogUpload);
  }

  Future<void> _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    try {
      emit(BlogLoading());

      if (event.title.isEmpty || event.content.isEmpty || event.poster_id.isEmpty) {
        emit(BlogFailure('All fields are required'));
        return;
      }

      final result = await uploadBlog(
        UploadBlogParams(
          title: event.title,
          content: event.content,
          poster_id: event.poster_id,
          categories: event.categories,
          image: event.image,
          edited_at: DateTime.now().toIso8601String(), // Ensure edited_at is passed correctly
        ),
      );

      result.fold(
        (failure) => emit(BlogFailure(failure.message)),
        (_) => emit(BlogSuccess()),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }
}
