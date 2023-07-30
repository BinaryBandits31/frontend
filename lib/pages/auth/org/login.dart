// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/org/reset.dart';
import 'package:frontend/pages/auth/user_login.dart';
import 'package:frontend/providers/org_provider.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/big_text.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:frontend/widgets/notify.dart';
import 'package:frontend/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginOrg extends StatefulWidget {
  const LoginOrg({super.key, required this.signUp});

  final Function signUp;
  @override
  State<LoginOrg> createState() => _LoginOrgState();
}

class _LoginOrgState extends State<LoginOrg> {
  final _formKey = GlobalKey<FormState>();
  String _organizationID = '';

  void _loginOrg(OrgProvider provider) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await provider.validateOrg(_organizationID);

      if (provider.organization != null) {
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('orgID', provider.organization!.id);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const UserLogin()));
      } else if (provider.error != null) {
        dangerMessage('${provider.error}');
      }
    }
  }

  // @override
  // void initState() {
  //   getValidationData();
  //   super.initState();
  // }

  // Future getValidationData() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   // DashboardPage if user loggedIn
  //   String? userToken = sharedPreferences.getString('userToken');
  //   if (userToken != null) {
  //     // if token valid => DashboardPage
  //     final res = await AuthServices.validateToken(userToken);
  //     if (res) {
  //       Get.to(() => const Dashboard());
  //     }
  //   }

  //   // UserLoginPage if Org LoggedIn
  //   String? orgID = sharedPreferences.getString('orgID');
  //   if (orgID != null) {
  //     OrgProvider orgProvider =
  //         Provider.of<OrgProvider>(context, listen: false);
  //     await orgProvider.fetchOrganization(orgID);
  //     if (orgProvider.organization != null) {
  //       Get.off(() => const UserLogin());
  //     }
  //   }
  //   // Else
  //   Get.off(() => const OrgAuth());
  // }

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
                    Consumer<OrgProvider>(
                      builder: (context, provider, _) => SubmitButton(
                        label: 'Login',
                        // isLoading: provider.isLoading,
                        onPressed: () => _loginOrg(provider),
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
        ),
      ),
    );
  }
}
