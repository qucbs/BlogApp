import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
