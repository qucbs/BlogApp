import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/feature/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogSupabaseSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadblogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
}

class BlogSupabaseSourceImpl implements BlogSupabaseSource {
  final SupabaseClient supabaseClient;
  BlogSupabaseSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(e.toString(), StackTrace.current);
    }
  }

  @override
  Future<String> uploadblogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      final filePath = '${blog.id}.jpg'; // or .png, based on your image
      await supabaseClient.storage.from('blog_images').upload(filePath, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(filePath);
    } catch (e) {
      throw ServerException(e.toString(), StackTrace.current);
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles(name)');

      return blogs.map<BlogModel>((blog) {
        final profile = blog['profiles'];
        final posterName = profile != null ? profile['name'] : null;

        return BlogModel.fromJson(blog).copywith(posterName: posterName);
      }).toList();
    } catch (e) {
      throw ServerException(e.toString(), StackTrace.current);
    }
  }
}
