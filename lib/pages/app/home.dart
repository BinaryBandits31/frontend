import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          appProvider.title!,
          style: const TextStyle(fontWeight: FontWeight.w300),
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
                  child: Text('Logout'),
                ),
              ],
              onSelected: (String value) {
                if (value == 'change_password') {
                  // Handle change password action
                } else if (value == 'logout') {
                  // Handle logout action
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const UserLogin(),
                  ));
                  final appProvider =
                      Provider.of<AppProvider>(context, listen: false);
                  appProvider.logOut();

                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  userProvider.logOut();
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
