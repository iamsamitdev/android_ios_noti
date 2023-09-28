// ignore_for_file: prefer_const_constructors, avoid_print, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Firebase Messaging Handler for Background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null){
    print('onBackgroundMessage: ${message.notification!.body} \n ${message.data}');
  }
}

class HomeLocalNoti extends StatefulWidget {
  const HomeLocalNoti({super.key});

  @override
  State<HomeLocalNoti> createState() => _HomeLocalNotiState();
}

class _HomeLocalNotiState extends State<HomeLocalNoti> {

  // Local Notification Plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize Local Notifications
  Future<void> _initializeLocalNotifications() async {

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    // for iOs foreground notification
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, 
      badge: true, 
      sound: true
    );

  }

  // Show a local notification
  Future<void> _showLocalNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'Your Channel Name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title,
    body,
    platformChannelSpecifics,
  );
}

  // Setup Notifications
  Future<void> _setupNotifications() async {

    // Firebase Messaging
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    print('token ==> $token');

    // Permission
    NotificationSettings notificationSettings = await firebaseMessaging.requestPermission();
    print('notificationSettings: $notificationSettings.authorizationStatus');

    // Firebase Messaging Handler
    // เมื่อแอพอยู่ในสถานะ Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null){
        print('onMessage: ${message.notification!.body} \n ${message.data}');
        // Show a local notification
        await _showLocalNotification(
          message.notification!.title!,
          message.notification!.body!,
        );
      }
    });

    // เมื่อแอพอยู่ในสถานะ Background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // เมื่อทำการกด Notification ที่แสดงในแถบ Status Bar
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('onMessageOpenedApp: ${message.notification!.body}\n ${message.data}');
      }
    });

  }

  @override
  void initState() {
    super.initState();
    _initializeLocalNotifications();
    _setupNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}