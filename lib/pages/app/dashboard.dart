import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/big_text.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(sH(20)),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png', // Replace with your app logo path
            width: 300,
            height: 300,
          ),
        ));
  }
}
