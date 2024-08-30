import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MediaServices {
  final ImagePicker _picker = ImagePicker();

  // MediaServices() {}

  Future<File?> getImageFromGallery() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return File(file.path);
    }
    return null;
  }
}
