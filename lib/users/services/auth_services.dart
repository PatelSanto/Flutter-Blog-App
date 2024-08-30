import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/user_profile.dart';
import 'package:flutter_blog_app/users/screens/auth/auth.dart';
import 'package:flutter_blog_app/users/screens/home/home_screen.dart';
import 'package:flutter_blog_app/users/services/database_services.dart';
import 'package:flutter_blog_app/users/services/storage_services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? user;
  // bool isLoggedIn = false;

  Widget checkLogin() {
    print("checkingLogin function called");
    return StreamBuilder<User?>(
      stream: _firebaseAuth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // User is signed in
          print("User is signed in: to home screen");
          user = snapshot.data;
          return HomeScreen();
        } else {
          // User is not signed in
          print("User is not signed in: to signup screen");
          return const Auth();
        }
      },
    );
  }

  Future<bool> login(String email, String password) async {
    print("login function called");
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final sp = await SharedPreferences.getInstance();
      if (credential.user != null) {
        await sp.setBool("GoogleLogin", false);

        user = credential.user;
        // go to home screen
        // snackbar will show

        return true;
      }
    } catch (e) {
      print("Error: $e");
      // snackbar("Login Failed.", "Please Enter valid Credentials.");
      print("login failed");

      return false;
    }
    return false;
  }

  Future<bool> signup(String email, String password) async {
    print("signup function called");
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final sp = await SharedPreferences.getInstance();
      if (credential.user != null) {
        await sp.setBool("GoogleLogin", false);
        user = credential.user;
        // go to HomeScreen
        // snackbar("Welcome $email", "Successfully Signed in.");
        return true;
      } else {
        // snackbar("Error", "Signin Failed.");
        return false;
      }
    } catch (e) {
      // snackbar("Error", "Signin Failed.");
      print("Error: $e");
    }
    return false;
  }

  Future<bool> handleGoogleSignIn(
      StorageService storageServices, DatabaseService databaseServices) async {
    print("handleGoogleSignIn function called");
    try {
      final sp = await SharedPreferences.getInstance();
      final userCredential = await signInWithGoogle();
      final user = userCredential?.user;
      final uid = user?.uid;
      final pfpicUrl = user?.photoURL;
      final email = user?.email;
      final name = user?.displayName;
      print("UID: $uid, \nemail: $email, \nname: $name, \npfpic: $pfpicUrl");

      if (user != null) {
        if (await sp.setBool("GoogleLogin", true)) {
          print("google login : ${sp.getBool("GoogleLogin")}");
          print(sp.getKeys());

          print("--------------Download Url: $pfpicUrl :--------------");
          if (pfpicUrl != null) {
            await databaseServices.createUserProfile(
              userProfile: UserProfile(
                  uid: uid, name: name, pfpURL: pfpicUrl, email: email),
            );
          } else {
            throw Exception("Unable to Upload user profile picture");
          }

          // Handle signed-in user (e.g., navigate to a new screen)
          // Get.off(() => const HomeScreen());
          this.user = userCredential?.user;
          // go to HomeScreen
          print('Signed in as: ${user.displayName}');
          // snackbar(
          //     "Welcome ${user.displayName}", "Successfully Signed in.");
          return true;
        } else {
          // snackbar("Error",
          // "Google Authentication Passed but error in shared preferences");
          return false;
        }
      } else {
        // snackbar("Error", "Google Signin Failed.");
        print("Gooogle signin failed");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    print("signInWithGoogle function called");
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<bool> logout() async {
    print("logout function called");
    try {
      await _firebaseAuth.signOut();
      // Get.offAllNamed("loginSignupPage");
      // go to signupPage
      user = null;
      return true;
    } catch (e) {
      print("Error: $e");
    }
    return false;
  }

  // void logoutDilog() {
  //   print("logoutDilog function called");
  //   Get.defaultDialog(
  //     title: "Login out",
  //     middleText: "Are sure you want to Logout?",
  //     confirm: OutlinedButton(
  //         onPressed: () async {
  //           final sp = await SharedPreferences.getInstance();
  //           if (sp.getBool("GoogleLogin") == true) {
  //             googleSignOut();
  //           } else {
  //             logout();
  //           }
  //         },
  //         child: const Text("Yes")),
  //     cancel: OutlinedButton(
  //         onPressed: () {
  //           Get.back();
  //         },
  //         child: const Text("No")),
  //   );
  // }

  Future<void> googleSignOut() async {
    print("googleSignOut function called");
    try {
      final sp = await SharedPreferences.getInstance();
      sp.clear();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      await sp.setBool("GoogleLogin", false);
      // Get.offAll(() => const LoginSignupScreen());
      // Get.offAllNamed("loginSignupPage");
      // go to signupPage
      print("Signed out of Google");
    } catch (e) {
      print("Error: $e");
    }
  }
}
