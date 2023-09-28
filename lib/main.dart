import 'package:flutter/material.dart';
import 'package:android_ios_noti/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:android_ios_noti/functions/firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  FirebaseService firebaseService = FirebaseService();
  await firebaseService.initializeFirebaseMessaging();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notification Android iOS',
      home: Welcome()
    );
  }
}
