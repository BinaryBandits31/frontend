import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/org/login.dart';
import 'package:frontend/pages/auth/org/register.dart';

class OrgAuth extends StatefulWidget {
  const OrgAuth({super.key});
  @override
  State<OrgAuth> createState() => _OrgAuthState();
}

class _OrgAuthState extends State<OrgAuth> {
  bool isLogged = true;

  void toggleLogin() {
    setState(() {
      isLogged = !isLogged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogged
        ? LoginOrg(signUp: toggleLogin)
        : RegisterOrg(login: toggleLogin);
  }
}
