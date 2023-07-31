import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/stock_item.dart';
import '../../../providers/stock_provider.dart';
import '../../../providers/app_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/data_page.dart';
import '../../auth/user_login.dart';

// class StockItemsPage extends StatefulWidget {
//   const StockItemsPage({super.key});
//
//   @override
//   State<StockItemsPage> createState() => _StockItemsPageState();
// }
//
// class _StockItemsPageState extends State<StockItemsPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((_) async {
//       final stockProvider =
//           Provider.of<StockProvider>(context, listen: false);
//       if (stockProvider.stockItems.isEmpty) {
//         await stockProvider.fetchStockItems();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final pageTitle = Provider.of<AppProvider>(context, listen: false)
//         .pathTitle!
//         .split(' > ')[1];
//     final stockProvider = Provider.of<StockProvider>(context);
//     final stockItems = stockProvider.filteredStockItems;
//
//     return DataPage(
//       refreshPageFunction: stockProvider.fetchStockItems,
//       isLoading: stockProvider.isLoading,
//       dataList: stockItems,
//       pageTitle: pageTitle,
//       columnNames: const [
//         'NAME',
//         'DESCRIPTION',
//         'PRICE',
//         'QUANTITY',
//         ""
//       ],
//       searchFunction: stockProvider.searchStockItem,
//       createNewDialog: Container(),
//       source: StockDataTableSource(stockItems),
//       adminPage: false,
//     );
//
//   }
// }
//
// class StockDataTableSource extends DataTableSource{
//   StockDataTableSource(this.stockItems);
//
//   final List<StockItem> stockItems;
//
//   @override
//   DataRow getRow(int index) {
//     final stockItem = stockItems[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(Text(stockItem.productName)),
//         DataCell(Text(stockItem.id)),
//         DataCell(Text(stockItem.quantity.toString())),
//         DataCell(Text(stockItem.expiryDate.toString())),
//         DataCell(
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.edit),
//               ),
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.delete),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get rowCount => stockItems.length;
//
//   @override
//   int get selectedRowCount => 0;
// }


class StockItemsPage extends StatelessWidget {

  const StockItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome!'),
          const Text('Products Stock Page'),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const UserLogin(),
              ));
              final appProvider =
                  Provider.of<AppProvider>(context, listen: false);
              appProvider.appDispose();

              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.userDispose();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
