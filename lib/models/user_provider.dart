import 'package:blog_app/header.dart';
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
    int? totalComments,
    int? totalLikes,
    int? noOfBlogs,
    Set<String>? blogIds,
    Set<String>? favoriteBlogs,
  }) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(state.uid);

    Map<String, dynamic> updatedData = {
      'name': name ?? state.name,
      'email': email ?? state.email,
      'pfpURL': profilePicUrl ?? state.pfpURL,
      'totalViews': totalViews ?? state.totalViews,
      'totalComments': totalComments ?? state.totalComments,
      'totalLikes': totalLikes ?? state.totalLikes,
      'noOfBlogs': noOfBlogs ?? state.noOfBlogs,
      'blogIds': blogIds ?? state.blogIds,
      'favoriteBlogs': favoriteBlogs ?? state.favoriteBlogs,
    };

    try {
      await userRef.update(updatedData);
      state = UserData(
        uid: state.uid,
        name: name ?? state.name,
        email: email ?? state.email,
        pfpURL: profilePicUrl ?? state.pfpURL,
        totalViews: totalViews ?? state.totalViews,
        totalComments: totalComments ?? state.totalComments,
        totalLikes: totalLikes ?? state.totalLikes,
        noOfBlogs: noOfBlogs ?? state.noOfBlogs,
        blogIds: blogIds ?? state.blogIds,
        favoriteBlogs: favoriteBlogs ?? state.favoriteBlogs,
      );
      print('Document updated successfully!');
    } catch (e) {
      print('Error updating document: $e');
    }
  }
}
