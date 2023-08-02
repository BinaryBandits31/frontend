import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/pages/app/admin/users/create_user_dialog.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/widgets/data_page.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchFellowUsers().then((value) =>
          Provider.of<BranchProvider>(context, listen: false).fetchBranches());
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = Provider.of<AppProvider>(context, listen: false)
        .pathTitle!
        .split(' > ')[1];
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final fellowUsers = userProvider.fellowUsers;

    return DataPage(
      refreshPageFunction: userProvider.fetchFellowUsers,
      isLoading: userProvider.isLoadingFellowUsers,
      dataList: fellowUsers!,
      pageTitle: pageTitle,
      columnNames: const [
        'USERNAME',
        'BRANCH',
        'ACTIVE',
      ],
      createNewDialog: CreateNewUserDialog(),
      source: UsersDataTableSource(fellowUsers),
      searchFunction: userProvider.searchFellowUsers,
      adminPage: true,
    );
  }
}

class UsersDataTableSource extends DataTableSource {
  final List<User> users;
  final branches =
      Provider.of<BranchProvider>(Get.context!, listen: true).branches;
  UsersDataTableSource(this.users);

  @override
  DataRow? getRow(int index) {
    if (index >= users.length) return null;
    final user = users[index];
    String branch = '*';
    if (user.branchId != '*') {
      branch = branches.firstWhere((e) => e.branchID == user.branchId).name;
    }

    return DataRow(cells: [
      DataCell(Text(user.username.toString())),
      DataCell(Text(branch)),
      DataCell(Text(user.isActive!.toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
