// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/big_text.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:frontend/widgets/notify.dart';
import 'package:frontend/widgets/text_field.dart';
import 'package:provider/provider.dart';

import '../../../providers/org_provider.dart';
import '../user_login.dart';

class RegisterOrg extends StatefulWidget {
  const RegisterOrg({
    super.key,
    required this.login,
  });

  final Function login;
  @override
  State<RegisterOrg> createState() => _RegisterOrgState();
}

class _RegisterOrgState extends State<RegisterOrg> {
  final _formKey = GlobalKey<FormState>();
  final _registrationData = {};

  void _signUpOrg() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final bool isRegistered = await AuthServices.signUp(_registrationData);
        if (isRegistered) {
          successMessage('Account successfully created!');

          final orgProvider = Provider.of<OrgProvider>(context, listen: false);
          await orgProvider.fetchOrganization(_registrationData['orgID']);

          if (orgProvider.organization != null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const UserLogin()));
          }
        }
      } catch (e) {
        dangerMessage(e.toString());
      }
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            onSaved: (value) {
                              _registrationData['orgName'] = value;
                            },
                          ),
                          LabeledTextField(
                            label: 'Organization ID',
                            isRequired: true,
                            onSaved: (value) {
                              _registrationData['orgID'] = value;
                            },
                          ),
                          LabeledTextField(
                            label: 'Email',
                            isRequired: true,
                            onSaved: (value) {
                              _registrationData['orgEmail'] = value;
                            },
                          ),
                          LabeledTextField(
                            label: 'Phone',
                            isRequired: true,
                            onSaved: (value) {
                              _registrationData['orgPhone'] = value;
                            },
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
                            onSaved: (value) {
                              _registrationData['fullName'] = value;
                            },
                          ),
                          LabeledTextField(
                            label: 'Password',
                            isRequired: true,
                            onSaved: (value) {
                              _registrationData['password'] = value;
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(sH(20)),
              SubmitButton(
                label: 'Create Account',
                isLoading: false,
                onPressed: () => _signUpOrg(),
              ),
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
