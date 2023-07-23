import 'package:flutter/material.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../models/branch.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/buttons.dart';
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
    final branchProvider = Provider.of<BranchProvider>(context);
    final branches = branchProvider.branches;
    return Padding(
        padding: EdgeInsets.only(top: sH(25), left: sH(25), right: sH(25)),
        child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Company Locations',
                            style: TextStyle(
                                fontSize: sH(25), fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: sH(10)),
                            child: TriggerButton(
                              title: 'CREATE NEW',
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: !branchProvider.isLoading,
                                  context: context,
                                  builder: (context) => CreateBranchDialog(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      addVerticalSpace(20),
                      // Search Section
                      Card(
                        color: AppColor.black1,
                        child: Padding(
                          padding: EdgeInsets.all(sH(20)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Search Field
                              SizedBox(
                                width: screenWidth * 0.3,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('What are you looking for?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextField()
                                  ],
                                ),
                              ),
                              // Search Button
                              TriggerButton(
                                title: 'SEARCH',
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Result Section
                      addVerticalSpace(20),
                      branchProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : branches.isNotEmpty
                              ? ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth),
                                  child: PaginatedDataTable(
                                      source: BranchDataTableSource(branches),
                                      header: // Result Options
                                          const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Locations Summary',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      rowsPerPage: branches.length >= 10
                                          ? 10
                                          : branches.length,
                                      headingRowHeight: sH(40),
                                      columns: const [
                                        DataColumn(label: Text('NAME')),
                                        DataColumn(label: Text('TYPE')),
                                        DataColumn(label: Text('')),
                                      ]),
                                )
                              : ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth),
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(sH(20)),
                                      child: Text(
                                        'No Data Found',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: sH(25)),
                                      ),
                                    ),
                                  ),
                                )
                    ],
                  ),
                )));
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
