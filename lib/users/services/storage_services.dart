import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  // StorageService() {}

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadUserPfpic(
      {required File file, required String uid}) async {
    try {
      Reference fileReference = firebaseStorage
          .ref('users/pfpics')
          .child("$uid${path.extension(file.path)}");

      UploadTask uploadTask = fileReference.putFile(file);

      return uploadTask.then((p) {
        if (p.state == TaskState.success) {
          return fileReference.getDownloadURL();
        }
        return null;
      });
    } catch (e) {
      print("Error uploading user profile pic: $e");
      return null;
    }
  }
}
