import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

void dangerMessage(String text) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text.capitalize!),
    duration: const Duration(seconds: 2),
  ));
}

void successMessage(String text) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Text(text.capitalize!),
    duration: const Duration(seconds: 2),
  ));
}

class NotificationBadge extends StatelessWidget {
  final IconData iconData;
  final int notificationCount;

  const NotificationBadge(
      {super.key, required this.iconData, required this.notificationCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          iconData,
          size: sH(32),
        ),
        if (notificationCount > 0)
          Positioned(
            right: -0.5,
            top: -5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.blue, // You can customize the background color
                shape: BoxShape.circle,
              ),
              child: Text(
                notificationCount.toString(),
                style: const TextStyle(
                  color: Colors.white, // You can customize the text color
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // You can adjust the font size
                ),
              ),
            ),
          ),
      ],
    );
  }
}
