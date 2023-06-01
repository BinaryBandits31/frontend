import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/org/auth.dart';
import 'package:frontend/theme/dark_theme.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EPR Frontend',
      home: const OrgAuth(),
      theme: darkTheme,
    );
  }
}
