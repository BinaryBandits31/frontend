import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // final dashboardData = context.watch<Map<dynamic, dynamic>>();

    return Padding(
        padding: EdgeInsets.all(sH(20)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png', // Replace with your app logo path
              width: 300,
              height: 300,
            ),
          ),
          // Text(dashboardData["salesSummary"]["totalEarnings"].toString())
        ]));
  }
}
