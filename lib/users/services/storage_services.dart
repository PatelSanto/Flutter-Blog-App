import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  // StorageService() {}

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadUserPfpic(
      {required File file, required String uid}) async {
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
  }

  Future<String?> uploadImageToChat( // for blog images
      {required File file, required String chatId}) async {
        
    Reference fileRef = firebaseStorage.ref('chats/$chatId').child(
        '${DateTime.now().toIso8601String()}${path.extension(file.path)}');
    UploadTask uploadTask = fileRef.putFile(file);

    return uploadTask.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
      return null;
    });
  }
}
