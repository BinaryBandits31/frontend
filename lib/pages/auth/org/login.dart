import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/org/reset.dart';
import 'package:frontend/pages/auth/user_login.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/big_text.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:frontend/widgets/text_field.dart';

class LoginOrg extends StatefulWidget {
  const LoginOrg({super.key, required this.signUp});

  final Function signUp;
  @override
  State<LoginOrg> createState() => _LoginOrgState();
}

class _LoginOrgState extends State<LoginOrg> {
  final _formKey = GlobalKey<FormState>();
  String _organizationID = '';

  void _loginOrg() {
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              addVerticalSpace(sH(100)),
              const BigText('Login to Your Organization'),
              addVerticalSpace(sH(20)),
              Container(
                padding: EdgeInsets.all(sH(10)),
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.35),
                height: screenHeight * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    LabeledTextField(
                      label: 'Organization ID',
                      isRequired: true,
                      onSaved: (value) => _organizationID = value!,
                    ),
                    addVerticalSpace(20),
                    SubmitButton(label: 'Login', onPressed: _loginOrg),
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
        ),
      ),
    );
  }
}
