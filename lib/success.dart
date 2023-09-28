// ignore_for_file: prefer_const_constructors, override_on_non_overriding_member, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? receivedArguments = Get.arguments;

    // You can now use receivedArguments to access the data.
    final String? firstData = receivedArguments?['first'];
    final String? secondData = receivedArguments?['second'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Success Page'),
            Text('First Data: $firstData'), // Display first data
            Text('Second Data: $secondData'), // Display second data
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
