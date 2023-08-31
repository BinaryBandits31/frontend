import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/models/stock_item.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/providers/stock_transfer_provider.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/custom_widgets.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:frontend/widgets/notify.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';

class StockTransferPage extends StatefulWidget {
  const StockTransferPage({super.key});

  @override
  State<StockTransferPage> createState() => _StockTransferPageState();
}

class _StockTransferPageState extends State<StockTransferPage> {
  List<Branch> _fromBranchList = [];
  Branch? _selectedFromBranch;
  StockItem? _displayedSearchItem;
  dynamic _newProductItem = {};
  int? stockLevel;
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();

  void _selectProduct(StockItem item) {
    if (item != _displayedSearchItem) {
      quantityFocusNode.requestFocus();
      setState(() {
        _displayedSearchItem = item;
        stockLevel = item.quantity;
      });
      _newProductItem['product_Id'] = item.stockItemID;
      _newProductItem['productName'] = item.productName;
    }
  }

  void confirmTransfer() async {
    final stockPurchaseProvider =
        Provider.of<StockTransferProvider>(context, listen: false);
    bool res = await stockPurchaseProvider.initiateTransfer();
    if (res) {
      successMessage('Stock transfer initiated.');
    } else {
      dangerMessage('Stock Transfer Failed');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final branchProvider =
          Provider.of<BranchProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final stockTransferProvider =
          Provider.of<StockTransferProvider>(context, listen: false);
      await stockTransferProvider.fetchAllStockItems();

      if (branchProvider.branches.isEmpty) {
        await branchProvider.fetchBranches();
      }
      for (Branch branch in branchProvider.branches) {
        if (branch.branchID == userProvider.user!.branchId) {
          setState(() {
            _selectedFromBranch = branch;
          });
        }
      }
      bool isNotOwner = userProvider.getLevel()! < 3;
      if (isNotOwner) {
        _fromBranchList.add(_selectedFromBranch!);
        stockTransferProvider.setCurrentBranch(_selectedFromBranch!);
      } else {
        setState(() {
          _fromBranchList = branchProvider.branches;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<StockTransferProvider>(Get.context!, listen: false)
          .disposeST();
    });
  }

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context, listen: true);
    final branchList = branchProvider.branches;

    final stockTransferProvider =
        Provider.of<StockTransferProvider>(context, listen: true);
    final stockItems = stockTransferProvider.stockItems;
    final List<StockItem> productList =
        Provider.of<StockTransferProvider>(context, listen: false).products;

    return SingleChildScrollView(
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
                          isLoading: branchProvider.isLoading,
                          labelText: 'From',
                          value: stockTransferProvider.currentBranch ??
                              _selectedFromBranch,
                          itemList: _fromBranchList,
                          displayItem: (Branch branch) => branch.name,
                          onChanged: (Branch? newValue) {
                            if (newValue != stockTransferProvider.toBranch) {
                              stockTransferProvider.setCurrentBranch(newValue!);
                            } else {
                              dangerMessage(
                                  'Please select different "from" and "to" locations.');
                            }
                          },
                        ),
                      ),
                      addHorizontalSpace(screenWidth * 0.05),
                      PaneContainer(
                        child: CustomDropDown<Branch>(
                          isLoading: branchProvider.isLoading,
                          labelText: 'To',
                          value: stockTransferProvider.toBranch,
                          itemList: branchList,
                          displayItem: (Branch branch) => branch.name,
                          onChanged: (Branch? newValue) {
                            if (newValue !=
                                stockTransferProvider.currentBranch) {
                              stockTransferProvider.setToBranch(newValue!);
                            } else {
                              dangerMessage(
                                  'Please select different "from" and "to" locations.');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(sH(20)),
                  //Search Product
                  PaneContainer(
                    child: CustomSearchField<StockItem>(
                      itemList: productList,
                      getItemName: (stockItem) => stockItem.productName,
                      onItemSelected: (stockItem) {
                        _selectProduct(stockItem);
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
                                      index.isOdd ? AppColor.grey1 : null,
                                  title: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              '${product['productName']}')),
                                      Expanded(
                                          child: Text('${product['quantity']}'))
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => stockTransferProvider
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
                            value: _displayedSearchItem != null
                                ? _displayedSearchItem!.productName
                                : '',
                          ),
                          Divider(color: AppColor.grey1),
                          CardField(
                            title: 'Stock Level',
                            value:
                                stockLevel != null ? stockLevel.toString() : '',
                          ),
                          Divider(color: AppColor.grey1),
                          CardField(
                            title: 'Quantity',
                            isValueWidget: true,
                            widget: TextFormField(
                              controller: quantityController,
                              focusNode: quantityFocusNode,
                              onTapOutside: (event) =>
                                  quantityFocusNode.unfocus(),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Divider(color: AppColor.grey1),
                          TriggerButton(
                              onPressed: () {
                                if (quantityController.text.isEmpty) {
                                  dangerMessage('Please Enter Quantity');
                                  return;
                                }
                                if (stockLevel! <
                                    int.parse(quantityController.text)) {
                                  dangerMessage('Not Enough Stock');
                                  return;
                                }

                                _newProductItem['quantity'] =
                                    quantityController.text;
                                stockTransferProvider
                                    .addSelectedProduct(_newProductItem);
                                quantityController.clear();
                                setState(() {
                                  stockLevel = null;
                                  _displayedSearchItem = null;
                                  _newProductItem = {};
                                });
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
                          label: 'Initiate Transfer',
                          onPressed: () => confirmTransfer()),
                      ElevatedButton(
                          onPressed: () {
                            stockTransferProvider.cancelPurchase();
                            quantityController.clear();
                            setState(() {
                              _displayedSearchItem = null;
                              stockLevel = null;
                              _newProductItem = {};
                            });
                          },
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
    );
  }
}
