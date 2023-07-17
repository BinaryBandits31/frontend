import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/user_login.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome!'),
          const Text('Dashboard Page'),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const UserLogin(),
              ));
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.logOut();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      )),
    );
  }
}
