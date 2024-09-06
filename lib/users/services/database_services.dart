import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blog_app/models/user.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference<UserData> _userCollection;
  // late AuthService _authService;

  // Singleton pattern to ensure a single instance
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal() {
    _userCollection =
        _firebaseFirestore.collection('users').withConverter<UserData>(
              fromFirestore: (snapshots, _) =>
                  UserData.fromJson(snapshots.data()!),
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

  Future<UserData?> fetchUserProfile(String uid) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> userProfileSnapshot =
        await _firebaseFirestore.collection('users').doc(uid).get();

    if (userProfileSnapshot.exists) {
      // Convert the document data to a UserProfile instance
      return UserData.fromJson(userProfileSnapshot.data()!);
    } else {
      // Handle case where the user profile document doesn't exist
      return null;
    }
  } catch (e) {
    print("Error fetching user profile: $e");
    return null;
  }
}
}
