import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/models/raw_material.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/raw_material_provider.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/custom_widgets.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:frontend/widgets/notify.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';

class ProductFabricationPage extends StatefulWidget {
  const ProductFabricationPage({super.key});

  @override
  State<ProductFabricationPage> createState() => _ProductFabricationPageState();
}

class _ProductFabricationPageState extends State<ProductFabricationPage> {
  List<Branch> _fromBranchList = [];
  Branch? _selectedCompanyLocation;
  Product? _displayedSearchItem;
  int? _displayedYield;
  final _submissionData = {};
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  List<dynamic> ingredientsAndStock = [];

  void _selectProduct(Product product) {
    if (product != _displayedSearchItem) {
      setState(() {
        ingredientsAndStock = [];
      });

      quantityFocusNode.requestFocus();
      setState(() {
        _displayedSearchItem = product;
      });
      List<RawMaterial> rawMaterials =
          Provider.of<RawMaterialProvider>(context, listen: false).rawMaterials;
      final selectedLocation =
          Provider.of<ProductProvider>(context, listen: false).selectedBranch;
      List<String> constKeys = product.constituents!.keys.toList();

      List constValues = product.constituents!.values.toList();
      List constDivisions = [];
      for (int i = 0; i < constKeys.length; i++) {
        String key = constKeys[i];
        final rm = rawMaterials.firstWhere((e) => e.id == key);
        String name = rm.name;
        String req = constValues[i].toString();
        String stock = rm.quantity![selectedLocation!.branchID].toString();
        setState(() {
          ingredientsAndStock.add({
            "name": name,
            "requiredStock": req,
            "actualStock": stock,
          });
        });
        constDivisions.add(int.parse(stock) ~/ int.parse(req));
      }
      setState(() {
        _displayedYield =
            constDivisions.reduce((curr, next) => curr < next ? curr : next);
      });
      _submissionData['id'] = product.id;
    }
  }

  void fabricateProduct() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (_displayedYield == null || quantityController.text.isEmpty) return;
    if (_displayedYield! < int.parse(quantityController.text)) {
      dangerMessage('Not Enough Raw Materials.');
      return;
    }
    _submissionData['quantity'] = int.parse(quantityController.text);
    _submissionData['branch_Id'] = productProvider.selectedBranch!.branchID;

    final rawMaterialProvider =
        Provider.of<RawMaterialProvider>(context, listen: false);
    bool res = await productProvider.fabricateProduct(_submissionData);
    if (res) {
      successMessage('Product Fabricated successfully.');
      clearData();
      await productProvider.fetchLocalProducts();
      await rawMaterialProvider.fetchRawMaterials();
    } else {
      dangerMessage('Something went wrong.');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final branchProvider =
          Provider.of<BranchProvider>(context, listen: false);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final rawMaterialsProvider =
          Provider.of<RawMaterialProvider>(context, listen: false);

      if (rawMaterialsProvider.rawMaterials.isEmpty) {
        await rawMaterialsProvider.fetchRawMaterials().then((value) => null);
      }

      if (branchProvider.branches.isEmpty) {
        await branchProvider.fetchBranches();
      }
      if (productProvider.localProducts.isEmpty) {
        await productProvider.fetchLocalProducts();
      }
      for (Branch branch in branchProvider.branches) {
        if (branch.branchID == userProvider.user!.branchId) {
          setState(() {
            _selectedCompanyLocation = branch;
          });
        }
      }
      bool isNotOwner = userProvider.getLevel()! < 3;
      if (isNotOwner) {
        _fromBranchList.add(_selectedCompanyLocation!);
        productProvider.setSelectedBranch(_selectedCompanyLocation!);
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
      Provider.of<ProductProvider>(Get.context!, listen: false)
          .productDispose();
    });
  }

  void clearData() {
    quantityController.clear();
    setState(() {
      _displayedSearchItem = null;
      _displayedYield = null;
      _submissionData.clear();
      ingredientsAndStock = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context, listen: true);
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    final products = productProvider.filteredLocalProducts;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Header
                  PaneContainer(
                    child: CustomDropDown<Branch>(
                      isLoading: branchProvider.isLoading,
                      labelText: 'Company Location',
                      value: productProvider.selectedBranch ??
                          _selectedCompanyLocation,
                      itemList: _fromBranchList,
                      displayItem: (Branch branch) => branch.name,
                      onChanged: (Branch? newValue) {
                        if (newValue != productProvider.selectedBranch) {
                          productProvider.setSelectedBranch(newValue!);
                        }
                      },
                    ),
                  ),
                  addVerticalSpace(sH(20)),
                  //Search Product
                  PaneContainer(
                    child: CustomSearchField<Product>(
                      itemList: products,
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
                                Expanded(child: Text('Raw Material')),
                                Expanded(child: Text('Required')),
                                Expanded(child: Text('In Stock')),
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
                              itemCount: ingredientsAndStock.length,
                              itemBuilder: (context, index) {
                                dynamic rmData = ingredientsAndStock[index];
                                return ListTile(
                                  tileColor:
                                      index.isOdd ? AppColor.grey1 : null,
                                  title: Row(
                                    children: [
                                      Expanded(
                                          child: Text('${rmData['name']}')),
                                      Expanded(
                                          child: Text(
                                              '${rmData['requiredStock']}')),
                                      Expanded(
                                          child:
                                              Text('${rmData['actualStock']}'))
                                    ],
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
                                ? _displayedSearchItem!.name
                                : '',
                          ),
                          Divider(color: AppColor.grey1),
                          CardField(
                            title: 'Possible Yield',
                            value: _displayedYield != null
                                ? _displayedYield.toString()
                                : '',
                          ),
                          Divider(color: AppColor.grey1),
                          CardField(
                            title: 'Quantity to Produce',
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
                          //Submit Transaction
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubmitButton(
                                  label: 'Fabricate Product',
                                  onPressed: () => fabricateProduct()),
                              ElevatedButton(
                                  onPressed: () {
                                    clearData();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.red),
                                  ))
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
