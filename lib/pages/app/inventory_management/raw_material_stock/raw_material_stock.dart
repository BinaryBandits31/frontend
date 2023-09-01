import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/models/raw_material.dart';
import 'package:frontend/pages/app/inventory_management/raw_material_stock/add_rm_dialog.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/providers/raw_material_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/widgets/custom_widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../models/stock_item.dart';
import '../../../../widgets/data_page.dart';

class RawMaterialStockPage extends StatefulWidget {
  const RawMaterialStockPage({super.key});

  @override
  State<RawMaterialStockPage> createState() => _RawMaterialStockPageState();
}

class _RawMaterialStockPageState extends State<RawMaterialStockPage> {
  bool isLoading = true;
  List<StockItem> stockItems = [];
  Branch? _selectedCompanyLocation;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final rawMaterialProvider =
          Provider.of<RawMaterialProvider>(context, listen: false);

      final branchProvider =
          Provider.of<BranchProvider>(context, listen: false);

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (rawMaterialProvider.rawMaterials.isEmpty) {
        await rawMaterialProvider.fetchRawMaterials();
      }

      if (branchProvider.branches.isEmpty) {
        await branchProvider.fetchBranches();
      }

      for (Branch branch in branchProvider.branches) {
        if (branch.branchID == userProvider.user!.branchId) {
          setState(() {
            _selectedCompanyLocation = branch;
          });
        }
      }

      setState(() {
        _selectedCompanyLocation ??= branchProvider.branches[0];
        rawMaterialProvider.setBranch(_selectedCompanyLocation!);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<RawMaterialProvider>(Get.context!, listen: false).disposeRM();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = Provider.of<AppProvider>(context, listen: false)
        .pathTitle!
        .split(' > ')[1];
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final rawMaterialProvider = Provider.of<RawMaterialProvider>(context);
    List<RawMaterial> rawMaterials = rawMaterialProvider.filteredRawMaterials;

    return DataPage(
      refreshPageFunction: rawMaterialProvider.fetchRawMaterials,
      isLoading: rawMaterialProvider.isLoading,
      dataList: rawMaterials,
      pageTitle: pageTitle,
      columnNames: const ['NAME', 'BASE UNIT', 'QUANTITY', ""],
      searchFunction: rawMaterialProvider.searchRawMaterial,
      createNewDialog: const SizedBox.shrink(),
      source: RawMaterialDataTableSource(rawMaterials), // Use
      adminPage: false, // the StockItemDataTableSource
      filterWidget: (userProvider.getLevel()! >= 3)
          ? CustomDropDown<Branch>(
              isLoading: branchProvider.isLoading,
              labelText: 'Company Location',
              value: _selectedCompanyLocation,
              itemList: branchProvider.branches,
              displayItem: (Branch branch) => branch.name,
              onChanged: (Branch? newValue) {
                if (newValue != _selectedCompanyLocation) {
                  setState(() {
                    _selectedCompanyLocation = newValue!;
                  });
                  rawMaterialProvider.setBranch(newValue!);
                }
              },
            )
          : null,
    );
  }
}

class RawMaterialDataTableSource extends DataTableSource {
  final List<RawMaterial> rawMaterials;

  RawMaterialDataTableSource(this.rawMaterials);

  @override
  DataRow getRow(int index) {
    final rawMaterialProvider = Provider.of<RawMaterialProvider>(Get.context!);
    final rawMaterial = rawMaterials[index];
    int quantity = 0;
    try {
      if (rawMaterialProvider.selectedBranch != null) {
        quantity =
            rawMaterial.quantity[rawMaterialProvider.selectedBranch!.branchID];
      }
    } catch (e) {
      null;
    }
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(rawMaterial.name)),
        DataCell(Text(rawMaterial.baseUnit)),
        DataCell(Text(quantity.toString())),
        DataCell(InkWell(
          child: const Icon(
            Icons.add,
            color: Colors.blue,
          ),
          onTap: () => showDialog(
            barrierDismissible: false,
            context: Get.context!,
            builder: (context) => AddRawMaterialDialog(rawMaterial),
          ),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rawMaterials.length;

  @override
  int get selectedRowCount => 0;
}
