// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:frontend/pages/app/home.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/providers/org_provider.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/big_text.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:frontend/widgets/text_field.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/user_provider.dart';
import '../../widgets/notify.dart';
import 'org/auth.dart';

class UserLogin extends StatefulWidget {
  final Widget? previousPage;

  const UserLogin({
    super.key,
    this.previousPage,
  });

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();
  final _userLoginData = {};

  void _loginUser(UserProvider provider) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await provider.fetchUserData(_userLoginData);

      if (provider.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', provider.user!.token!);

        await Provider.of<AppProvider>(Get.context!, listen: false)
            .fetchDashboardData();

        Get.off(() => const HomePage());
      } else if (provider.error != null) {
        dangerMessage('${provider.error}');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.previousPage.toString() == 'HomePage') {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Future.delayed(const Duration(milliseconds: 200)).then((_) async {
          await AuthServices.clearAppData();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                addVerticalSpace(sH(100)),
                BigText(
                  orgProvider.organization!.name.capitalize,
                  color: Colors.blue,
                ),
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
                            onSaved: (value) {
                              _userLoginData['username'] = value;
                            },
                          ),
                          LabeledTextField(
                            label: 'Password',
                            isRequired: true,
                            onSaved: (value) {
                              _userLoginData['password'] = value;
                            },
                          ),
                          addVerticalSpace(sH(20)),
                          Consumer<UserProvider>(
                            builder: (context, provider, _) => SubmitButton(
                              label: 'Login',
                              // isLoading: provider.isLoading,
                              onPressed: () => _loginUser(provider),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(sH(30)),
                InkWell(
                  onTap: () async {
                    orgProvider.orgDispose();
                    final sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.remove('orgID');

                    Get.off(() => const OrgAuth());
                  },
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
