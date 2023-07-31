import 'package:flutter/material.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_provider.dart';
import '../../../widgets/data_page.dart';
import '../admin/products/products.dart';

class ProductPricePage extends StatefulWidget {
  const ProductPricePage({super.key});

  @override
  State<ProductPricePage> createState() => _ProductPricePageState();
}

class _ProductPricePageState extends State<ProductPricePage> {

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
        ""
      ],
      searchFunction: productProvider.searchProduct,
      createNewDialog: Container(), // Use the create product dialog
      source:
      ProductDataTableSource(products), //
      adminPage: false,// Use the ProductDataTableSource
    );
  }
}

