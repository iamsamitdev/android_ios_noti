import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:android_ios_noti/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:android_ios_noti/functions/firebase_services.dart';

// Firebase Messaging Handler for Background
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   if (message.notification != null) {
//     print('onBackgroundMessage: ${message.notification!.body} \n ${message.data}');
//     // Handle the background message here if needed.
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  final FirebaseService firebaseService = FirebaseService();

  MyApp({super.key}) {
    // Initialize Firebase Messaging and set callbacks
    firebaseService.initializeFirebaseMessaging(
      onMessageCallback: (RemoteMessage message) {
        // Handle onMessage callback
        print("Received onMessage: ${message.notification?.body}");
        // Add your custom handling logic here
      },
      onMessageOpenedAppCallback: (RemoteMessage message) {
        // Handle onMessageOpenedApp callback
        print("Received onMessageOpenedApp: ${message.notification?.body}");
        // Add your custom handling logic here
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notification Android iOS',
      home: Welcome()
    );
  }
}
