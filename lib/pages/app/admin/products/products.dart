import 'package:flutter/material.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/pages/app/admin/products/create_product_dialog.dart';
import 'package:frontend/pages/app/admin/products/edit_product_dialog.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/widgets/data_page.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      if (productProvider.products.isEmpty) {
        await productProvider.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = Provider.of<AppProvider>(context, listen: false)
        .pathTitle!
        .split(' > ')[1];
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider
        .filteredProducts; // Use the products list from the ProductProvider

    return DataPage(
      refreshPageFunction: productProvider.fetchProducts,
      isLoading:
          productProvider.isLoading, // Use isLoading from the ProductProvider
      dataList: products, // Use the products list
      pageTitle: pageTitle,
      columnNames: const [
        'NAME',
        'DESCRIPTION',
        'PRICE',
        'QUANTITY',
        "",
      ],
      searchFunction: productProvider.searchProduct,
      createNewDialog: CreateProductDialog(), // Use the create product dialog
      source:
          ProductDataTableSource(products), // Use
      adminPage: true,// the ProductDataTableSource
    );
  }
}

class ProductDataTableSource extends DataTableSource {
  // final productProvider =
  //     Provider.of<ProductProvider>(Get.context!, listen: true);

  final userProvider = Provider.of<UserProvider>(Get.context!, listen: false);
  final List<Product> products;

  ProductDataTableSource(this.products);

  @override
  DataRow? getRow(int index) {
    if (index >= products.length) return null;
    final product = products[index];
    return DataRow(cells: [
      DataCell(Text(product.name)),
      DataCell(Text(product.description)),
      DataCell(Text(product.price.toString())),
      DataCell(Text(product.quantity.toString())),
      userProvider.getLevel()! >= 2
          ? DataCell(const SizedBox(),
              showEditIcon: true,
              onTap: () => showDialog(
                    barrierDismissible: false,
                    context: Get.context!,
                    builder: (context) => EditProductDialog(product),
                  ))
          : const DataCell(Text('')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products.length;

  @override
  int get selectedRowCount => 0;
}
