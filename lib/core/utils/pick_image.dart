import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

Future<dynamic> pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    
    if (kIsWeb) {
      // Handle web platform
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final bytes = await pickedImage.readAsBytes();
        return bytes;
      }
    } else {
      // Handle mobile platforms
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        return File(pickedImage.path);
      }
    }
    return null;
  } catch (e) {
    return null;
  }
}
