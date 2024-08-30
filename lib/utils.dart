import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/firebase_options.dart';
import 'package:flutter_blog_app/users/services/auth_services.dart';
import 'package:flutter_blog_app/users/services/database_services.dart';
import 'package:flutter_blog_app/users/services/media_services.dart';
import 'package:flutter_blog_app/users/services/storage_services.dart';
import 'package:get_it/get_it.dart';

Future<void> setupFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Firebase app is initialized!');
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<MediaServices>(MediaServices());
  getIt.registerSingleton<StorageService>(StorageService());
  getIt.registerSingleton<DatabaseService>(DatabaseService());
}
