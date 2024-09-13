
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/models/blog.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/users/widgets/snackbar.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference<UserData> _userCollection;

  // Singleton pattern to ensure a single instance
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal() {
    _userCollection = _firebaseFirestore
        .collection('users')
        .withConverter<UserData>(
          fromFirestore: (snapshots, _) => UserData.fromJson(snapshots.data()!),
          toFirestore: (userProfile, _) => userProfile.toJson(),
        );
  }

  Future<void> createUserProfile({required UserData userProfile}) async {
    try {
      await _userCollection.doc(userProfile.uid).set(userProfile);
    } catch (e) {
      print("Error creating user profile: $e");
    }
  }
}

Stream<List<Blog>> getUserBlogs(String? uid) {
  CollectionReference blogsRef = FirebaseFirestore.instance.collection('blogs');
  return blogsRef
      .where('authorUid', isEqualTo: uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Blog.fromDocument(doc);
    }).toList();
  });
}

Future<UserData> getUserDetailsFromUid(String uid) async {
  try {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference<UserData> userCollection = firebaseFirestore
        .collection('users')
        .withConverter<UserData>(
          fromFirestore: (snapshots, _) => UserData.fromJson(snapshots.data()!),
          toFirestore: (userData, _) => userData.toJson(),
        );

    final docSnapshot = await userCollection.doc(uid).get();

    if (docSnapshot.exists) {
      UserData userDetails = docSnapshot.data()!;
      return userDetails;
    } else {
      return Future.error("User not found");
    }
  } catch (e) {
    return Future.error("Failed to fetch user data : $e");
  }
}

Future<bool> deleteBlog(BuildContext context, String id) async {
  try {
    final bool res = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Are you sure you want to delete this Blog?"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('blogs')
                      .doc(id)
                      .delete();
                  snackbarToast(
                      context: context,
                      title: "Blog Deleted!",
                      icon: Icons.delete_forever);
                  Navigator.of(context).pop();
                  print('Blog deleted');
                },
              ),
            ],
          );
        });
    return res;
  } catch (e) {
    print("error deleting blog: $e");
    return false;
  }
}

//  Future<void> uploadBlog({
//   required BuildContext context,
//   required String titleController,
//   required String contentController,
//   required String readingTimeController,
//   required String authorController,
//   required File selectedImage,
//   required UserData userData,
//   required dynamic ref,

//  }) async {
//     if (titleController.isEmpty ||
//         contentController.isEmpty ||
//         readingTimeController.isEmpty ||
//         authorController.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please fill all fields and select an image')),
//       );
//       return;
//     }

//     try {
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       Reference storageRef =
//           FirebaseStorage.instance.ref().child('blog_images/$fileName');
//       UploadTask uploadTask = storageRef.putFile(selectedImage);

//       TaskSnapshot taskSnapshot = await uploadTask;
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//       // final userData = ref.watch(userDataNotifierProvider);

//       // Create Blog object
//       Blog newBlog = Blog(
//         id: '',
//         title: titleController,
//         content: contentController,
//         author: authorController,
//         authorUid: userData.uid.toString(),
//         imageUrl: downloadUrl,
//         views: 0,
//         comments: 0,
//         readingTime: int.parse(readingTimeController),
//       );

//       // Save blog details to Firestore
//       DocumentReference docRef = await FirebaseFirestore.instance
//           .collection('blogs')
//           .add(newBlog.toMap());
//       await docRef.update({'id': docRef.id});

//       ref.read(userDataNotifierProvider.notifier).updateUserData(
//         noOfBlogs: userData.noOfBlogs + 1,
//         blogIds: [...userData.blogIds, docRef.id],
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Blog created successfully!')),
//       );
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to upload blog: $e')),
//       );
//     }
//   }