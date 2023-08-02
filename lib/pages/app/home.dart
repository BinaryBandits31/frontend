import 'package:flutter/material.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:frontend/widgets/notify.dart';
import 'package:frontend/widgets/text_field.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AppProvider>(context, listen: false).checkExpiryAlert();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: true);
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: NotificationBadge(
                iconData: Icons.table_rows_rounded,
                notificationCount: appProvider.alerts),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: AppColor.black1,
        title: Text(
          appProvider.pathTitle!,
          style: TextStyle(fontSize: sH(20), fontWeight: FontWeight.w300),
        ),
        actions: [
          // Profile Icon
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'change_password',
                  child: Text('Change Password'),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
              onSelected: (String value) async {
                if (value == 'change_password') {
                  // Handle change password action
                  showDialog(
                    context: context,
                    builder: (context) => ChangePasswordDialog(),
                  );
                } else if (value == 'logout') {
                  await AuthServices.appLogout();
                }
              },
              child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
      body: Consumer<AppProvider>(builder: (context, provider, child) {
        return provider.selectedTab!;
      }),
    );
  }
}

class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _updatePasswordData = {};

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String userID = userProvider.user!.id;
    _updatePasswordData['employee_Id'] = userID;

    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Update Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              margin: false,
              label: 'Old Password',
              isRequired: true,
              onSaved: (value) {
                _updatePasswordData['old_Password'] = value;
              },
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'New Password',
              isRequired: true,
              onSaved: (value) {
                _updatePasswordData['new_Password'] = value;
              },
            ),
          ],
        ),
        actions: [
          SubmitButton(
            label: 'Create',
            onPressed: () async {
              final res =
                  await AuthServices.updateUserPassword(_updatePasswordData);
              if (res) {
                successMessage('Password updated successfully!');
                Navigator.of(Get.context!).pop();
              } else {
                dangerMessage('Something went wrong.');
              }
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
