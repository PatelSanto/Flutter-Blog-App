
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blog_app/models/user_profile.dart';
import 'package:flutter_blog_app/users/services/auth_services.dart';
import 'package:get_it/get_it.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _userCollection;
  // CollectionReference? _chatCollection;
  late AuthService _authService;

  DatabaseService() {
    _authService = GetIt.instance.get<AuthService>();
    setupCollectionReference();
  }

  void setupCollectionReference() {
    _userCollection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshots, _) =>
                  UserProfile.fromJson(snapshots.data()!),
              toFirestore: (userProfile, _) => userProfile.toJson(),
            );
    // _chatCollection =
    //     _firebaseFirestore.collection('chats').withConverter<Chat>(
    //           fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
    //           toFirestore: (chat, _) => chat.toJson(),
    //         );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _userCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfile() {
    return _userCollection
        ?.where("uid", isNotEqualTo: _authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  // Future<bool> checkChatExists(String uid1, String uid2) async {
  //   String chatID = generateChatId(uid1: uid1, uid2: uid2);
  //   final result = await _chatCollection?.doc(chatID).get();
  //   if (result != null) {
  //     return result.exists;
  //   } else {
  //     return false;
  //   }
  // }

  // Future<void> createNewChat(String uid1, String uid2) async {
  //   String chatID = generateChatId(uid1: uid1, uid2: uid2);
  //   final docref = _chatCollection!.doc(chatID);
  //   final chat = Chat(id: chatID, participants: [uid1, uid2], messages: []);
  //   await docref.set(chat);
  // }

  // Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2) {
  //   String chatID = generateChatId(uid1: uid1, uid2: uid2);
  //   return _chatCollection?.doc(chatID).snapshots()
  //       as Stream<DocumentSnapshot<Chat>>;
  // }

  // Future<void> sendChatMessage(
  //     String uid1, String uid2, Message message) async {
  //   String chatID = generateChatId(uid1: uid1, uid2: uid2);
  //   final docref = _chatCollection!.doc(chatID);
  //   await docref.update({
  //     "messages": FieldValue.arrayUnion(
  //       [
  //         message.toJson(),
  //       ],
  //     )
  //   });
  // }

  // Future<void> updateUserProfile({required UserProfile userProfile}) async{
  //   await userCollection?.doc(userProfile.uid).update(userProfile.toJson());
  // }

  // Future<void> deleteUserProfile({required String uid}) async {
  //   await userCollection?.doc(uid).delete();
  // }

  // Future<UserProfile?> getUserProfile({required String uid}) async {
  // }
}
