import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    super.key,
    required this.login,
  });

  final Function login;
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Register an Organization'),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: TextButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Dashboard(),
                  )),
              child: const Text(
                'SIGN UP',
                style: TextStyle(color: Colors.green),
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account?'),
            const SizedBox(width: 10),
            InkWell(
              onTap: () => widget.login(),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
        )
      ],
    )));
  }
}
