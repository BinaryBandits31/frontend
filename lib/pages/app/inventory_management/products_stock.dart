import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';
import '../../../models/stock_item.dart';
import 'package:intl/intl.dart';
import '../../../widgets/data_page.dart';

class ProductStockPage extends StatefulWidget {
  const ProductStockPage({super.key});

  @override
  State<ProductStockPage> createState() => _ProductStockPageState();
}

class _ProductStockPageState extends State<ProductStockPage> {
  bool isLoading = true;
  List<StockItem> stockItems = [];
  Branch? _selectedCompanyLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final branchProvider =
          Provider.of<BranchProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);

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
      });
      productProvider.setSelectedBranch(_selectedCompanyLocation!);

      await productProvider.fetchProductStock();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = Provider.of<AppProvider>(context, listen: false)
        .pathTitle!
        .split(' > ')[1];
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context);

    List<StockItem> stockList = productProvider.filteredProductStock;

    return DataPage(
      refreshPageFunction: productProvider.fetchProductStock,
      isLoading:
          productProvider.isLoading, // Use isLoading from the StockProvider
      dataList: stockList, // Use the stockItems list
      pageTitle: pageTitle,
      columnNames: const [
        'NAME',
        'QUANTITY',
        'EXPIRY DATE',
      ],
      searchFunction: productProvider.searchProductStock,
      createNewDialog: const SizedBox.shrink(),
      source: StockItemDataTableSource(stockList), // Use
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
                  productProvider.setSelectedBranch(newValue!);
                }
              },
            )
          : null,
    );
  }
}

class StockItemDataTableSource extends DataTableSource {
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
        DataCell(Text(DateFormat('EEEE, MMM d, yyyy HH:mm')
            .format(DateTime.parse(stockItem.expiryDate!)))),
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
