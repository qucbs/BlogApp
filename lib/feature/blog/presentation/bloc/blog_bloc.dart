import 'dart:io';
import 'package:blog_app/feature/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;

  BlogBloc({required this.uploadBlog}) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onblogupload);
  }

  void _onblogupload(BlogUpload event, Emitter<BlogState> emit) async {

    final result = await uploadBlog(
      UploadBlogParams(
        image: event.image,
        title: event.title,
        content: event.content,
        categories: event.categories,
        poster_id: event.poster_id,
      ),
    );

    result.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blog) => emit(BlogSuccess()),
    );
  }
}
