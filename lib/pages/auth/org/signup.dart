import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/big_text.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:frontend/widgets/text_field.dart';

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
  final _formKey = GlobalKey<FormState>();

  void _signUpOrg() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Dashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addVerticalSpace(100),
              const BigText('Register an Organization'),
              addVerticalSpace(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(sH(10)),
                    width: screenWidth * 0.35,
                    child: Center(
                      child: Column(
                        children: [
                          const Text('Organization Details'),
                          addVerticalSpace(sH(50)),
                          LabeledTextField(
                            label: 'Name',
                            isRequired: true,
                            onSaved: (value) {},
                          ),
                          LabeledTextField(
                            label: 'Email',
                            isRequired: true,
                            onSaved: (value) {},
                          ),
                          LabeledTextField(
                            label: 'Country',
                            isRequired: true,
                            onSaved: (value) {},
                          ),
                          LabeledTextField(
                            label: 'Branch Location',
                            isRequired: true,
                            onSaved: (value) {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(sH(10)),
                    width: screenWidth * 0.35,
                    child: Center(
                      child: Column(
                        children: [
                          const Text('Admin Account'),
                          addVerticalSpace(sH(50)),
                          LabeledTextField(
                            label: 'Full Name',
                            isRequired: true,
                            onSaved: (value) {},
                          ),
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
                          LabeledTextField(
                            label: 'Phone Number',
                            isRequired: true,
                            onSaved: (value) {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(sH(20)),
              SubmitButton(
                  onPressed: () => _signUpOrg(), label: 'Create Account'),
              addVerticalSpace(sH(10)),
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
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
