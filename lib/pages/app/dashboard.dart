import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/big_text.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../auth/user_login.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.user!.username;

    return Padding(
      padding: EdgeInsets.all(sH(20)),
      child: Column(
        children: [
          BigText('Welcome $userName'),
        ],
      ),
    );
  }
}
