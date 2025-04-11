import 'dart:io';
import 'dart:typed_data';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/feature/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewScreen extends StatefulWidget {
  const AddNewScreen({super.key});

  @override
  State<AddNewScreen> createState() => _AddNewScreenState();
}

class _AddNewScreenState extends State<AddNewScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedCategories = [];
  File? image;
  Uint8List? webImage; // For web image

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        if (pickedImage is File) {
          image = pickedImage;
          webImage = null; // Clear web image if needed
        } else if (pickedImage is Uint8List) {
          webImage = pickedImage;
          image = null; // Clear file image if needed
        }
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedCategories.isNotEmpty &&
        (image != null || webImage != null)) {
      final appUserState = context.read<AppUserCubit>().state;

      if (appUserState is! AppuserSignedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be signed in to upload a blog'),
            backgroundColor: AppColors.background,
          ),
        );
        return;
      }

      final posterId = appUserState.user.id;
      final imageToUpload = image;

      if (imageToUpload == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image'),
            backgroundColor: AppColors.background,
          ),
        );
        return;
      }

      context.read<BlogBloc>().add(
        BlogUpload(
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          poster_id: posterId,
          categories: selectedCategories,
          image: imageToUpload, // Send either File or Uint8List
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all the fields and select at least one category',
          ),
          backgroundColor: AppColors.background,
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Blog',
          style: TextStyle(color: Color.fromARGB(255, 177, 175, 175)),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                uploadBlog();
              },
              icon: const Icon(Icons.done),
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.background,
              ),
            );
            print('Error ----------------- : ${state.error}');
          } else if (state is BlogSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Blog uploaded successfully!'),
                backgroundColor: AppColors.background,
              ),
            );
            Navigator.pop(context); // Navigate back after success
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: Loader());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    (image != null || webImage != null)
                        ? Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 250,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  image != null
                                      ? Image.file(image!, fit: BoxFit.cover)
                                      : Image.memory(
                                        webImage!,
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                        )
                        : GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: DottedBorder(
                            dashPattern: [10, 4],
                            color: const Color.fromARGB(255, 103, 103, 103),
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            strokeCap: StrokeCap.round,
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open, size: 40),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Upload Your Image',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                              'Technology',
                              'Health',
                              'Science',
                              'Programming',
                            ].map((category) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedCategories.contains(category)) {
                                      selectedCategories.remove(category);
                                    } else {
                                      selectedCategories.add(category);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(
                                      category,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor:
                                        selectedCategories.contains(category)
                                            ? Color.fromRGBO(112, 94, 250, 1)
                                            : null,
                                    side:
                                        selectedCategories.contains(category)
                                            ? null
                                            : const BorderSide(
                                              color: Color.fromARGB(
                                                255,
                                                103,
                                                103,
                                                103,
                                              ),
                                              width: 1,
                                            ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog Title',
                    ),
                    const SizedBox(height: 20),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog Content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
