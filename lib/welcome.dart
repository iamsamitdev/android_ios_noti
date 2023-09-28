// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  // Test Send Push Notification
  void testSendPushNotification() async {

    // url
    String url = 'https://fcm.googleapis.com/fcm/send';

    // Config http headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAA9HiERic:APA91bGk8CkQxvaKdJQZBJtocu7fb5rQVojoqq4pP5xTXlKKOev6q2XwwpZ0_0rQBiVwacO_TJ5UkXAZkpkoL4Fh0h_c6T_X3Z1OXCaE1qjoIpXruXXl4Dp_ai55B9ayNcSlMhTMw2mq'
    };

    var data = 
      {
        "to": "dZ6r6GkPS_-mNaLqIotpya:APA91bFjFzLRnv-8aKlV7VG8V5HUhgKSI5qktvH_Mj-X7oLq647Ug-jQJtx28TXUk0SaN1B_HlrOGXVdadGPF2Gv4hBrNcROwxum3iO4F_gdVgVygsijjFu-ye9wtboOociV4144mX9H",
        "notification": {
          "title": "This is title 5",
          "body": "test notification 5",
          "icon": "myicon",
          "sound": "default"
        },
        "android": {"priority": "high"},
        "apns": {
          "headers": {"apns-priority": "10"},
          "payload": {
            "aps": {"sound": "default"}
          }
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "notification_foreground": "true",
          "notification_android_sound": "default",
          "page": "page5",
          "link": "room1",
          "id": "1"
        }
      };

      try {
        var response = await http.post(
          Uri.parse(url), 
          headers: headers, 
          body: jsonEncode(data)
        );
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      } catch (e) {
        print(e);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Welcome Screen'),
            ElevatedButton(
              onPressed: () {
                testSendPushNotification();
              },
              child: const Text('Test Send Push Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
