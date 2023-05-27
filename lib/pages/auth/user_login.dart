import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard.dart';

import 'org/auth.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('User Login'),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: TextButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Dashboard(),
                    )),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.green),
                )),
          ),
          InkWell(
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const OrgAuth(),
            )),
            child: const Text(
              'Log Out Organization',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      )),
    );
  }
}
