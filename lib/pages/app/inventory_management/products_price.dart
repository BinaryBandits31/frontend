import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_provider.dart';
import '../../../providers/user_provider.dart';
import '../../auth/user_login.dart';

class ProductsPricePage extends StatelessWidget {
  const ProductsPricePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome!'),
          const Text('Products Price Page'),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const UserLogin(),
              ));
              final appProvider =
                  Provider.of<AppProvider>(context, listen: false);
              appProvider.logOut();

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
      ),
    );
  }
}
