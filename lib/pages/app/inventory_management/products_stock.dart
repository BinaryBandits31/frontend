import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/stock_item.dart';
import '../../../providers/stock_provider.dart';
import '../../../providers/app_provider.dart';
import 'package:intl/intl.dart';
import '../../../services/stock_items_services.dart';
import '../../../widgets/data_page.dart';

class ProductStockPage extends StatefulWidget {
  const ProductStockPage({super.key});

  @override
  State<ProductStockPage> createState() => _ProductStockPageState();
}

class _ProductStockPageState extends State<ProductStockPage> {

  bool isLoading = true;
  List<StockItem> stockItems = [];

  @override
  void initState() {
    super.initState();
    StockServices.getStockItems().then((value) => setState(() {
      stockItems = value;
      isLoading = false;
    }));
  }

  @override
  Widget build(BuildContext context) {

    return DataPage(
      refreshPageFunction: (){},
      isLoading: isLoading, // Use isLoading from the StockProvider
      dataList: stockItems, // Use the stockItems list
      pageTitle: "STOCK ITEMS",
      columnNames: const [
        'NAME',
        'QUANTITY',
        'EXPIRY DATE',
      ],
      searchFunction: (){},
      createNewDialog: Container(), // Use the create stockItem dialog
      source:
      StockItemDataTableSource(stockItems), // Use
      adminPage: false,// the StockItemDataTableSource
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
