import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/models/supplier.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/stock_purchase_provider.dart';
import 'package:frontend/providers/supplier_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/custom_widgets.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:frontend/widgets/notify.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StockPurchasePage extends StatefulWidget {
  const StockPurchasePage({super.key});

  @override
  State<StockPurchasePage> createState() => _StockPurchasePageState();
}

class _StockPurchasePageState extends State<StockPurchasePage> {
  DateTime? _selectedExpiryDate;
  List<Branch> branchList = [];
  Branch? _selectedBranch;
  Supplier? _selectedSupplier;
  Product? _selectedSearchProduct;
  final dynamic _newProductItem = {};
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();

  void _handleExpiryDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedExpiryDate = selectedDate;
    });
    _newProductItem['expiry'] = DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  void _selectProduct(Product product) {
    if (product != _selectedSearchProduct) {
      quantityFocusNode.requestFocus();
      setState(() {
        _selectedSearchProduct = product;
        _selectedExpiryDate = null;
      });
      _newProductItem['product_Id'] = product.id;
      _newProductItem['productName'] = product.name;
    }
  }

  void confirmPurchase() async {
    final stockPurchaseProvider =
        Provider.of<StockPurchaseProvider>(context, listen: false);
    bool res = await stockPurchaseProvider.confirmPurchase();
    if (res) {
      successMessage('Stock Purchased Successfully');
    } else {
      dangerMessage('Stock Purchase Failed');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final branchProvider =
          Provider.of<BranchProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final supplierProvider =
          Provider.of<SupplierProvider>(context, listen: false);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      if (branchProvider.branches.isEmpty) {
        await branchProvider.fetchBranches();
      }
      if (supplierProvider.suppliers.isEmpty) {
        await supplierProvider.fetchSuppliers();
      }
      if (productProvider.products.isEmpty) {
        await productProvider.fetchProducts();
      }
      for (Branch branch in branchProvider.branches) {
        if (branch.branchID == userProvider.user!.branchId) {
          setState(() {
            _selectedBranch = branch;
          });
        }
      }
      bool isNotAdmin = userProvider.getLevel()! < 4;
      if (isNotAdmin) {
        branchList.add(_selectedBranch!);
      } else {
        setState(() {
          branchList = branchProvider.branches;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final supplierProvider =
        Provider.of<SupplierProvider>(context, listen: true);
    final List<Supplier> supplierList = supplierProvider.suppliers;
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    final List<Product> productList = productProvider.products;
    final stockPurchaseProvider =
        Provider.of<StockPurchaseProvider>(context, listen: true);
    final stockItems = stockPurchaseProvider.stockItems;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Container(
          height: screenHeight * 0.91,
          padding: EdgeInsets.symmetric(horizontal: sH(20), vertical: sH(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //left Pane
              Expanded(
                child: Column(
                  children: [
                    //Header
                    Row(
                      children: [
                        PaneContainer(
                          child: CustomDropDown<Branch>(
                            labelText: 'Branch',
                            value: stockPurchaseProvider.currentBranch ??
                                _selectedBranch,
                            itemList: branchList,
                            displayItem: (Branch branch) => branch.name,
                            onChanged: (Branch? newValue) {
                              setState(() {
                                _selectedBranch = newValue;
                              });
                              stockPurchaseProvider.setBranch(newValue!);
                            },
                          ),
                        ),
                        addHorizontalSpace(screenWidth * 0.05),
                        PaneContainer(
                          child: CustomDropDown<Supplier>(
                              labelText: 'Supplier',
                              displayItem: (Supplier supplier) => supplier.name,
                              onChanged: (Supplier? newValue) {
                                setState(() {
                                  _selectedSupplier = newValue!;
                                });
                                stockPurchaseProvider.setSupplier(newValue!);
                              },
                              value: stockPurchaseProvider.supplier ??
                                  _selectedSupplier,
                              itemList: supplierList),
                        )
                      ],
                    ),
                    addVerticalSpace(sH(20)),
                    //Search Product
                    PaneContainer(
                      child: CustomSearchField<Product>(
                        itemList: productList,
                        getItemName: (product) => product.name,
                        onItemSelected: (product) {
                          _selectProduct(product);
                        },
                      ),
                    ),
                    addVerticalSpace(sH(20)),
                    //Entered Product List
                    Expanded(
                      child: PaneContainer(
                        child: Column(
                          children: [
                            const ListTile(
                              title: Row(
                                children: [
                                  Expanded(child: Text('Product Name')),
                                  Expanded(child: Text('Quantity')),
                                  Expanded(child: Text('Expiry')),
                                ],
                              ),
                              trailing: Icon(
                                Icons.delete,
                                color: Colors.transparent,
                                size: 50,
                              ),
                            ),
                            const Divider(),
                            Expanded(
                              child: ListView.builder(
                                itemCount: stockItems.length,
                                itemBuilder: (context, index) {
                                  dynamic product = stockItems[index];
                                  return ListTile(
                                    tileColor:
                                        index.isEven ? AppColor.grey1 : null,
                                    title: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                                '${product['productName']}')),
                                        Expanded(
                                            child:
                                                Text('${product['quantity']}')),
                                        Expanded(
                                            child:
                                                Text('${product['expiry']}')),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => stockPurchaseProvider
                                          .removeIndexedProduct(index),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              addHorizontalSpace(sW(20)),
              // right Pane
              SizedBox(
                width: screenWidth * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Selected Product Detail
                    PaneContainer(
                        height: screenHeight * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CardField(
                              title: 'Product Name',
                              value: _selectedSearchProduct != null
                                  ? _selectedSearchProduct!.name
                                  : '',
                            ),
                            Divider(color: AppColor.grey1),
                            CardField(
                              title: 'Quantity',
                              isValueWidget: true,
                              widget: TextFormField(
                                controller: quantityController,
                                focusNode: quantityFocusNode,
                                // initialValue: _selectedQuantity.toString(),
                                onChanged: (newValue) {
                                  // stockPurchaseProvider.updateSelectedQuantity(
                                  //     int.parse(newValue!));
                                  _newProductItem['quantity'] = newValue;
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Divider(color: AppColor.grey1),
                            CardField(
                              title: 'Expiry Date',
                              isValueWidget: true,
                              widget: CustomDatePicker(
                                selectedDate: _selectedExpiryDate,
                                onDateSelected: _handleExpiryDateSelected,
                              ),
                            ),
                            Divider(color: AppColor.grey1),
                            TriggerButton(
                                onPressed: () {
                                  stockPurchaseProvider
                                      .addSelectedProduct(_newProductItem);
                                },
                                title: 'Add to List')
                          ],
                        )),

                    //Submit Transaction
                    PaneContainer(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SubmitButton(
                            label: 'Confirm Purchase',
                            onPressed: () => confirmPurchase()),
                        ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ))
                      ],
                    ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaneContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  const PaneContainer(
      {super.key, required this.child, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(padding: EdgeInsets.all(sH(10)), child: child),
      ),
    );
  }
}

class CardField extends StatelessWidget {
  final String title;
  final String? value;
  final bool isValueWidget;
  final Widget? widget;

  const CardField(
      {super.key,
      required this.title,
      this.value,
      this.isValueWidget = false,
      this.widget});

  @override
  Widget build(BuildContext context) {
    double customFontSize = sH(18);

    return Row(
      children: [
        Expanded(
            child: Text(
          title,
          style: TextStyle(fontSize: customFontSize),
        )),
        Expanded(
          child: !isValueWidget
              ? Card(
                  margin: EdgeInsets.zero,
                  color: AppColor.grey1,
                  child: Center(
                    child: Text(
                      ' ${value ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: customFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : widget!,
        )
      ],
    );
  }
}
