import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is empty';
        }
        return null;
      },
      maxLines: null,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
