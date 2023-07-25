import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/pages/app/home.dart';
import 'package:frontend/pages/auth/org/auth.dart';
import 'package:frontend/pages/auth/user_login.dart';
import 'package:frontend/providers/org_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/colors.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? userToken = sharedPreferences.getString('userToken');
    String? orgID = sharedPreferences.getString('orgID');
    Widget location = const OrgAuth();

    // UserLoginPage if Org LoggedIn
    if (orgID != null) {
      OrgProvider orgProvider =
          Provider.of<OrgProvider>(Get.context!, listen: false);
      bool isValidOrg = await orgProvider.validateOrg(orgID);
      if (isValidOrg) {
        location = const UserLogin();
        // DashboardPage if user loggedIn
        if (userToken != null) {
          // if token valid => DashboardPage
          UserProvider userProvider =
              Provider.of<UserProvider>(Get.context!, listen: false);
          bool isValidToken = await userProvider.validateToken(userToken);
          if (isValidToken) {
            location = const HomePage();
          }
        }
      }
    }
    Future.delayed(const Duration(seconds: 1), () => Get.off(() => location));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png', // Replace with your app logo path
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            CircularProgressIndicator(
              color: AppColor.orange3,
            ), // You can use any loading indicator here
          ],
        ),
      ),
    );
  }
}
