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
      final branchProvider =
          Provider.of<BranchProvider>(context, listen: false);
      if (branchProvider.branches.isEmpty) {
        await branchProvider.fetchBranches();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = Provider.of<AppProvider>(context, listen: false)
        .pathTitle!
        .split(' > ')[1];
    final branchProvider = Provider.of<BranchProvider>(context, listen: true);
    final branches = branchProvider.filteredBranches;

    return DataPage(
      refreshPageFunction: branchProvider.fetchBranches,
      isLoading: branchProvider.isLoading,
      dataList: branches,
      pageTitle: pageTitle,
      columnNames: const ['NAME', 'TYPE', ''],
      createNewDialog: CreateBranchDialog(),
      source: BranchDataTableSource(branches),
      searchFunction: branchProvider.searchBranch,
      adminPage: true,
    );
  }
}

class BranchDataTableSource extends DataTableSource {
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
                barrierDismissible: false,
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
