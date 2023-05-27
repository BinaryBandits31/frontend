import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/org/reset.dart';
import 'package:frontend/pages/auth/user_login.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.signUp});

  final Function signUp;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Organization Login'),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const UserLogin())),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.green),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account?'),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => widget.signUp(),
                child: const Text(
                  'Sing Up',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ResetOrgID(),
            )),
            child: const Text(
              'Reset ID',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      )),
    );
  }
}
