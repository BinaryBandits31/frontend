import 'package:flutter/material.dart';
import 'package:frontend/models/raw_material.dart';
import 'package:frontend/pages/app/admin/raw_materials/create_rm_dialog.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/providers/raw_material_provider.dart';
import 'package:frontend/widgets/data_page.dart';
import 'package:provider/provider.dart';

class RawMaterialsPage extends StatefulWidget {
  const RawMaterialsPage({super.key});

  @override
  State<RawMaterialsPage> createState() => _RawMaterialsPageState();
}

class _RawMaterialsPageState extends State<RawMaterialsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final rawMaterialProvider =
          Provider.of<RawMaterialProvider>(context, listen: false);

      if (rawMaterialProvider.rawMaterials.isEmpty) {
        await rawMaterialProvider.fetchRawMaterials();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = Provider.of<AppProvider>(context, listen: false)
        .pathTitle!
        .split(' > ')[1];
    final rawMaterialProvider = Provider.of<RawMaterialProvider>(context);
    List<RawMaterial> rawMaterials = rawMaterialProvider.filteredRawMaterials;

    return DataPage(
      refreshPageFunction: rawMaterialProvider.fetchRawMaterials,
      isLoading: rawMaterialProvider.isLoading,
      dataList: rawMaterials,
      pageTitle: pageTitle,
      columnNames: const [
        'NAME',
        'PACKAGE',
        'BASE UNIT',
        'QTY PER PACK',
        'PRICE',
      ],
      createNewDialog: CreateRMDialog(),
      source: RawMaterialsTableSource(rawMaterials),
      searchFunction: rawMaterialProvider.searchRawMaterial,
      adminPage: true,
    );
  }
}

class RawMaterialsTableSource extends DataTableSource {
  final List<RawMaterial> rawMaterials;

  RawMaterialsTableSource(this.rawMaterials);

  @override
  DataRow? getRow(int index) {
    if (index >= rawMaterials.length) return null;
    final rawMaterial = rawMaterials[index];

    return DataRow(cells: [
      DataCell(Text(rawMaterial.name)),
      DataCell(Text(rawMaterial.package)),
      DataCell(Text(rawMaterial.baseUnit)),
      DataCell(Text(rawMaterial.qtyPerPack.toInt().toString())),
      DataCell(Text(rawMaterial.price.toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rawMaterials.length;

  @override
  int get selectedRowCount => 0;
}
