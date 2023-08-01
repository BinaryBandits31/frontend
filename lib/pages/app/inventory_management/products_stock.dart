import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/stock_item.dart';
import '../../../providers/stock_provider.dart';
import '../../../providers/app_provider.dart';
import 'package:intl/intl.dart';
import '../../../widgets/data_page.dart';

class ProductStockPage extends StatefulWidget {
  const ProductStockPage({super.key});

  @override
  State<ProductStockPage> createState() => _ProductStockPageState();
}

class _ProductStockPageState extends State<ProductStockPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final stockProvider =
      Provider.of<StockProvider>(context, listen: false);
      if (stockProvider.stockItems.isEmpty) {
        await stockProvider.fetchStockItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = Provider.of<AppProvider>(context, listen: false)
        .pathTitle!
        .split(' > ')[1];
    final stockProvider = Provider.of<StockProvider>(context);
    final stockItems = stockProvider
        .filteredStockItems; // Use the stockItems list from the StockProvider

    return DataPage(
      refreshPageFunction: stockProvider.fetchStockItems,
      isLoading:
      stockProvider.isLoading, // Use isLoading from the StockProvider
      dataList: stockItems, // Use the stockItems list
      pageTitle: pageTitle,
      columnNames: const [
        'NAME',
        'QUANTITY',
        'EXPIRY DATE',
      ],
      searchFunction: stockProvider.searchStockItem,
      createNewDialog: Container(), // Use the create stockItem dialog
      source:
      StockItemDataTableSource(stockItems), // Use
      adminPage: true,// the StockItemDataTableSource
    );
  }
}

class StockItemDataTableSource extends DataTableSource{
  final List<StockItem> stockItems;

  StockItemDataTableSource(this.stockItems);

  @override
  DataRow getRow(int index) {
    final stockItem = stockItems[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(stockItem.productName)),
        DataCell(Text(stockItem.quantity.toString())),
        DataCell(Text(DateFormat('EEEE, MMM d, yyyy HH:mm').format(DateTime.parse(stockItem.expiryDate)))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => stockItems.length;

  @override
  int get selectedRowCount => 0;
}