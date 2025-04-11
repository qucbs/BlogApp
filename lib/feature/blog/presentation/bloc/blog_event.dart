part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final String title;
  final String content;
  final String poster_id;
  final List<String> categories;
  final File image;

  BlogUpload({
    required this.title,
    required this.content,
    required this.poster_id,
    required this.categories,
    required this.image,
  });
}
