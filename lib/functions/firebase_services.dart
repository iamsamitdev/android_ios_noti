// ignore_for_file: avoid_print, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_field, override_on_non_overriding_member

// import 'package:android_ios_noti/success.dart';
// import 'package:android_ios_noti/welcome.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Callbacks for handling messages
  Function(RemoteMessage)? onMessageCallback;
  Function(RemoteMessage)? onMessageOpenedAppCallback;

  FirebaseService({
    this.onMessageCallback,
    this.onMessageOpenedAppCallback,
  });

  // Initialize Firebase Messaging
 Future<Map<String, Object?>> initializeFirebaseMessaging({required Null Function(RemoteMessage message) onMessageCallback, required Null Function(RemoteMessage message) onMessageOpenedAppCallback}) async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();
    NotificationSettings notificationSettings =
        await _firebaseMessaging.requestPermission();
    NotificationResponse? tappedNotificationResponse =
        await _initializeLocalNotifications();
    return {
      'token': token,
      'authorizationStatus': notificationSettings.authorizationStatus,
      'tappedNotificationResponse': tappedNotificationResponse,
    };
  }

  // Initialize Local Notifications
  Future<NotificationResponse?> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );
    NotificationResponse? tappedNotificationResponse;
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        if (notificationResponse.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          tappedNotificationResponse = notificationResponse;
        }
      },
      onDidReceiveBackgroundNotificationResponse: null,
    );
    return tappedNotificationResponse;
  }

  // Show a local notification
  Future<void> showLocalNotification(
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

  // Handle Message Method onMessage
  void handleOnMessage(RemoteMessage message) {
    if (message.notification != null) {
      // print('onMessage: ${message.notification!.body} \n ${message.data}');
      if (onMessageCallback != null) {
        onMessageCallback!(message);
      }
    }
  }

  // Handle Message Method onMessageOpenedApp
  void handleOnMessageOpenedApp(RemoteMessage message) {
    if (message.notification != null) {
      // print('onMessageOpenedApp: ${message.notification!.body}\n ${message.data}');
      if (onMessageOpenedAppCallback != null) {
        onMessageOpenedAppCallback!(message);
      }
    }
  }

}
