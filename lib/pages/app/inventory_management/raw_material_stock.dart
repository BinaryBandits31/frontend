import 'package:flutter/material.dart';
import 'package:frontend/models/raw_material.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/providers/raw_material_provider.dart';
import 'package:provider/provider.dart';
import '../../../models/stock_item.dart';
import '../../../widgets/data_page.dart';

class RawMaterialStockPage extends StatefulWidget {
  const RawMaterialStockPage({super.key});

  @override
  State<RawMaterialStockPage> createState() => _RawMaterialStockPageState();
}

class _RawMaterialStockPageState extends State<RawMaterialStockPage> {
  bool isLoading = true;
  List<StockItem> stockItems = [];

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
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<RawMaterialProvider>(context, listen: false).disposeRM();
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
        'DESCRIPTION',
        'QUANTITY',
      ],
      searchFunction: rawMaterialProvider.searchRawMaterial,
      createNewDialog: const SizedBox.shrink(),
      source: RawMaterialDataTableSource(rawMaterials), // Use
      adminPage: false, // the StockItemDataTableSource
    );
  }
}

class RawMaterialDataTableSource extends DataTableSource {
  final List<RawMaterial> rawMaterials;

  RawMaterialDataTableSource(this.rawMaterials);

  @override
  DataRow getRow(int index) {
    final rawMaterial = rawMaterials[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(rawMaterial.name)),
        DataCell(Text(rawMaterial.desc)),
        DataCell(Text(rawMaterial.quantity.toString())),
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
