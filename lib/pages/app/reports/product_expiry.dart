import 'package:flutter/material.dart';
import 'package:frontend/models/stock_item.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/widgets/report_page.dart';
import 'package:provider/provider.dart';

class ProductExpiryReportPage extends StatefulWidget {
  const ProductExpiryReportPage({super.key});

  @override
  State<ProductExpiryReportPage> createState() =>
      _ProductExpiryReportPageState();
}

class _ProductExpiryReportPageState extends State<ProductExpiryReportPage> {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final String pageTitle = appProvider.pathTitle!.split(' > ')[1];
    final expiringStock = appProvider.expiringStock;

    return ReportPage(
      dataList: expiringStock,
      pageTitle: pageTitle,
      columnNames: const [
        'NAME',
        'QUANTITY',
        'EXPIRY DATE',
      ],
      source: ExpiringStockDataTableSource(expiringStock),
    );
  }
}

class ExpiringStockDataTableSource extends DataTableSource {
  // final supplierProvider =
  //     Provider.of<SupplierProvider>(Get.context!, listen: true);
  final List<StockItem?> expiringStock;

  ExpiringStockDataTableSource(this.expiringStock);

  @override
  DataRow? getRow(int index) {
    if (index >= expiringStock.length) return null;
    final stock = expiringStock[index];
    return DataRow(cells: [
      DataCell(Text(stock!.productName)),
      DataCell(Text(stock.quantity.toString())),
      DataCell(Text(
        stock.expiryDate,
        style: const TextStyle(color: Colors.red),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => expiringStock.length;

  @override
  int get selectedRowCount => 0;
}
