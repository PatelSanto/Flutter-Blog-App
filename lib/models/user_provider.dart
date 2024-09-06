import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_provider.g.dart';

@riverpod
class UserDataNotifier extends _$UserDataNotifier {
  @override
  UserData build() {
    // Initial empty user state
    return UserData(uid: "", name: "", email: "");
  }

  Future<void> fetchUserData(String? uid) async {
    try {
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      CollectionReference<UserData> userCollection =
          firebaseFirestore.collection('users').withConverter<UserData>(
                fromFirestore: (snapshots, _) =>
                    UserData.fromJson(snapshots.data()!),
                toFirestore: (userData, _) => userData.toJson(),
              );

      final docSnapshot = await userCollection.doc(uid).get();

      if (docSnapshot.exists) {
        state = docSnapshot.data()!;
      } else {
        print("User with uid $uid not found.");
      }
    } catch (e) {
      print("Failed to fetch user data: $e");
    }
  }

  void updateUserData({
    String? name,
    String? email,
    String? profilePicUrl,
    int? totalViews,
    int? totalComents,
    int? totalLikes,
    int? noOfBlogs,
    List<String>? blogIds,
  }) {
    state = UserData(
      uid: state.uid, // Keep the existing UID
      name: name ?? state.name,
      email: email ?? state.email,
      pfpURL: profilePicUrl ?? state.pfpURL,
      totalViews: totalViews ?? state.totalViews,
      totalComments: totalComents ?? state.totalComments,
      totalLikes: totalLikes ?? state.totalLikes,
      noOfBlogs: noOfBlogs ?? state.noOfBlogs,
      blogIds: blogIds ?? state.blogIds,
    );
  }
}

