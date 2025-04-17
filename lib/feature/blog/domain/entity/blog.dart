class Blog {
  final String id;
  final String poster_id;
  final String title;
  final String content;
  final String image_url;
  final List<String> categories;
  final DateTime edited_at;
  final String? posterName;

  Blog({
    required this.poster_id,
    required this.id,
    required this.title,
    required this.content,
    required this.image_url,
    required this.categories,
    required this.edited_at,
    this.posterName
  });
}
