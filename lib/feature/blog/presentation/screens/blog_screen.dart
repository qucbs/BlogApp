import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/feature/blog/presentation/widgets/blog_card.dart';
import 'package:blog_app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blog App',
          style: TextStyle(color: Color.fromARGB(255, 177, 175, 175)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(addnewscreen);
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            print('eror --------------------------- ${state.error}');
            showErrorSnackbar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogDisplaySuccess) {
            if (state.blogs.isEmpty) {
              return const Center(
                child: Text(
                  'No blogs yet. Create your first blog!',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(blog: blog);
              },
              itemCount: state.blogs.length,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
