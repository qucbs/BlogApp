import 'package:blog_app/routes.dart';
import 'package:flutter/material.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App' , style: TextStyle(color: Color.fromARGB(255, 177, 175, 175))),
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: () {
            Navigator.of(context).pushNamed(addnewscreen);
          }, icon: const Icon(Icons.add)),
        )],
        centerTitle: true,
      ),
    );
  }
}
