part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

class BlogUpload extends BlogEvent {
  final String title;
  final String content;
  final List<String> categories;
  final String poster_id;
  final File image; // Changed to File
  final String edited_at;

  BlogUpload({
    required this.title,
    required this.content,
    required this.categories,
    required this.poster_id,
    required this.image,
    required this.edited_at,
  });
}

final class BlogFetchAllBlogs extends BlogEvent {}