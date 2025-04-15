import 'package:blog_app/feature/blog/domain/entity/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.title,
    required super.content,
    required super.image_url,
    required super.categories,
    required super.edited_at,
    required super.poster_id,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'poster_id': poster_id,
      'content': content,
      'image_url': image_url,
      'categories': categories,
      'editedat': edited_at.toIso8601String(), // Ensure edited_at is serialized
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      title: map['title'] as String,
      poster_id: map['poster_id'] as String,
      content: map['content'] as String,
      image_url: map['image_url'] as String,
      categories: List<String>.from(map['categories'] ?? []),
      edited_at:
          map['editedat'] != null
              ? DateTime.parse(map['editedat']) // Parse edited_at from JSON
              : DateTime.now(),
    );
  }

  BlogModel copywith({
    String? id,
    String? title,
    String? content,
    String? image_url,
    List<String>? categories,
    DateTime? edited_at,
    String? poster_id,
  }) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      image_url: image_url ?? this.image_url,
      categories: categories ?? this.categories,
      edited_at: edited_at ?? this.edited_at, // Ensure edited_at is copied
      poster_id: poster_id ?? this.poster_id,
    );
  }

  @override
  String toString() {
    return 'BlogModel(id: $id, title: $title, content: $content, image_url: $image_url, categories: $categories, edited_at: $edited_at, poster_id: $poster_id)';
  }
}
