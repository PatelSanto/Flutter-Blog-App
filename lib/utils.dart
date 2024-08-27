import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/firebase_options.dart';

Future<void> setupFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Firebase app is initialized!');
}

Future<void> registerServices() async {
  //
}