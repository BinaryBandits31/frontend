import 'package:flutter/material.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/providers/supplier_provider.dart';
import 'package:frontend/utils/constants.dart';
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
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: true);
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
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
                  // Handle logout action
                  Get.off(() => const UserLogin());

                  Provider.of<AppProvider>(context, listen: false).appDispose();

                  Provider.of<UserProvider>(context, listen: false)
                      .userDispose();

                  Provider.of<BranchProvider>(context, listen: false)
                      .branchDispose();

                  Provider.of<SupplierProvider>(context, listen: false)
                      .supplierDispose();

                  final sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove('userToken');
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
