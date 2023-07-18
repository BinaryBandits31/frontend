import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/org/auth.dart';
import 'package:frontend/theme/dark_theme.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'providers/org_provider.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<OrgProvider>(create: (_) => OrgProvider()),
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EPR Frontend',
        home: const OrgAuth(),
        theme: darkTheme,
      ),
    );
  }
}
