import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/org/reset.dart';
import 'package:frontend/pages/auth/user_login.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/big_text.dart';
import 'package:frontend/widgets/helper_widgets.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.signUp});

  final Function signUp;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _organizationID = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint('Organization ID: $_organizationID');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const UserLogin()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Form(
          key: _formKey,
          child: Column(
            children: [
              addVerticalSpace(100),
              const BigText('Login to Your Organization'),
              addVerticalSpace(20),
              Container(
                padding: EdgeInsets.all(sH(10)),
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.35),
                height: screenHeight * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Organization ID'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the organization ID';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _organizationID = value!;
                      },
                    ),
                    addVerticalSpace(20),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppColor.orange3),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            )),
                        onPressed: _submitForm,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.black1,
                              fontSize: sH(20)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ResetOrgID())),
                      child: const Text(
                        'Forgot ID?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () => widget.signUp(),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: AppColor.orange2),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
