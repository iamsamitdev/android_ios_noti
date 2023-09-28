// ignore_for_file: avoid_print, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_field, override_on_non_overriding_member

import 'package:android_ios_noti/success.dart';
// import 'package:android_ios_noti/welcome.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

// Firebase Messaging Handler for Background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print(
        'onBackgroundMessage: ${message.notification!.body} \n ${message.data}');
    // Handle the background message here if needed.
  }
}

class FirebaseService {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize Firebase Messaging
  Future<void> initializeFirebaseMessaging() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    // Get the device token
    String? token = await _firebaseMessaging.getToken();
    print('Firebase token: $token');

    // Request notification permission
    NotificationSettings notificationSettings =
        await _firebaseMessaging.requestPermission();
    print(
        'Notification authorization status: ${notificationSettings.authorizationStatus}');

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Set up handlers for different message types
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('onMessage: ${message.notification!.body} \n ${message.data}');
        // Show a local notification
        _showLocalNotification(message.notification!.title!,
            message.notification!.body!, message.data['page']);
      }
    });

    // Firebase Messaging Handler for Background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Set up handlers for interaction with the message
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(
            'onMessageOpenedApp: ${message.notification!.body}\n ${message.data}');
        // You can handle the message when the app is opened from a notification here.
        if (message.data['page'] == "page5") {
          // Navigation to success page with material page route
          Get.to(SuccessPage());
        }
      }
    });
  }

  // Initialize Local Notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // Handle notification tapped logic here
        if (notificationResponse.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          print(
              'Notification forground tapped ${notificationResponse.payload}');
          if (notificationResponse.payload == "page5") {
            // Navigation to success page with material page route
            Get.to(SuccessPage());
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: null,
    );
  }

  // Show a local notification
  Future<void> _showLocalNotification(
       String title, String body, String data) async {
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
        payload: data);
  }
}