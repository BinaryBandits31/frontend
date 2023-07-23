import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/widgets/data_page.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'create_branch_dialog.dart';
import 'edit_branch_dialog.dart';

class CompanyLocationsPage extends StatefulWidget {
  const CompanyLocationsPage({super.key});

  @override
  State<CompanyLocationsPage> createState() => _CompanyLocationsPageState();
}

class _CompanyLocationsPageState extends State<CompanyLocationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<BranchProvider>(context, listen: false).fetchBranches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = Provider.of<AppProvider>(context, listen: false)
        .pathTitle!
        .split(' > ')[1];
    final branchProvider = Provider.of<BranchProvider>(context);
    final branches = branchProvider.branches;

    return DataPage(
      isLoading: branchProvider.isLoading,
      dataList: branches,
      pageTitle: pageTitle,
      columnNames: const ['NAME', 'TYPE', ''],
      createNewDialog: CreateBranchDialog(),
      source: BranchDataTableSource(branches),
    );
  }
}

class BranchDataTableSource extends DataTableSource {
  final branchProvider =
      Provider.of<BranchProvider>(Get.context!, listen: false);
  final List<Branch> branches;

  BranchDataTableSource(this.branches);

  @override
  DataRow? getRow(int index) {
    if (index >= branches.length) return null;
    final branch = branches[index];
    return DataRow(cells: [
      DataCell(Text(branch.name.toString())),
      DataCell(Text(branch.type)),
      DataCell(const SizedBox(),
          showEditIcon: true,
          onTap: () => showDialog(
                barrierDismissible: !branchProvider.isLoading,
                context: Get.context!,
                builder: (context) => EditBranchDialog(branch),
              )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => branches.length;

  @override
  int get selectedRowCount => 0;
}
