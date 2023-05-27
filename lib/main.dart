import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/org/auth.dart';
import 'package:frontend/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EPR Frontend',
      color: AppColor.blackBG,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: AppColor.orange3),
      //   useMaterial3: true,
      // ),
      home: const OrgAuth(),
    );
  }
}
