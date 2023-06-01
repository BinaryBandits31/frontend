import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/big_text.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:frontend/widgets/text_field.dart';
import 'package:get/get.dart';

import 'org/auth.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();

  void _loginUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint('Hello thereo');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                addVerticalSpace(sH(100)),
                const BigText('{Organization Name}'),
                addVerticalSpace(sH(50)),
                Container(
                  height: screenHeight * 0.4,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'User Login',
                        style: TextStyle(
                          fontSize: sH(30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: [
                          LabeledTextField(
                            label: 'Username',
                            isRequired: true,
                            onSaved: (value) {},
                          ),
                          LabeledTextField(
                            label: 'Password',
                            isRequired: true,
                            onSaved: (value) {},
                          ),
                          addVerticalSpace(sH(20)),
                          SubmitButton(
                            label: 'Login',
                            onPressed: () => _loginUser(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(sH(30)),
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
            ),
          ),
        ),
      ),
    );
  }
}


// Container(
//             margin: const EdgeInsets.symmetric(vertical: 20),
//             child: TextButton(
//                 onPressed: () =>
                    
//                 child: const Text(
//                   'LOGIN',
//                   style: TextStyle(color: Colors.green),
//                 )),
//           ),
          