import 'package:flutter/material.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/providers/supplier_provider.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/notify.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/app_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/drawer.dart';
import '../auth/user_login.dart';

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
