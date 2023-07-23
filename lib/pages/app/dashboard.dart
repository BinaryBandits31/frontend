import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../auth/user_login.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Welcome'),
        const Text('Dashboard Page'),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const UserLogin(),
            ));
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            userProvider.userDispose();
          },
          child: const Text(
            'Log Out',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    ));
  }
}
