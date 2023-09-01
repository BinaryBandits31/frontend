import 'package:flutter/material.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/models/raw_material.dart';
import 'package:frontend/pages/app/admin/users/create_user_dialog.dart';
import 'package:frontend/providers/org_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/raw_material_provider.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/custom_widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/helper_widgets.dart';
import '../../../../widgets/notify.dart';
import '../../../../widgets/text_field.dart';

class CreateProductDialog extends StatelessWidget {
  const CreateProductDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isManufacturingOrg = Provider.of<OrgProvider>(context, listen: false)
        .organization!
        .isManufacturer;

    return isManufacturingOrg
        ? const CreateManufactureProduct()
        : const CreateManufactureProduct();
  }
}

class CreatePurchaseProduct extends StatefulWidget {
  const CreatePurchaseProduct({
    super.key,
  });

  @override
  State<CreatePurchaseProduct> createState() => _CreatePurchaseProductState();
}

class _CreatePurchaseProductState extends State<CreatePurchaseProduct> {
  final _createProductData = {};

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    // _createProductData['quantity'] = 0;

    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('New Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              margin: false,
              label: 'Name',
              isRequired: true,
              onSaved: (value) {
                _createProductData['name'] = value;
              },
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Description',
              isRequired: true,
              onSaved: (value) {
                _createProductData['desc'] = value;
              },
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Price',
              isRequired: true,
              onSaved: (value) {
                if (value != null) {
                  _createProductData['price'] = double.parse(value);
                }
              },
              inputType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          SubmitButton(
            label: 'Create',
            onPressed: () async {
              final res = await productProvider
                  .createProduct(Product.fromJson(_createProductData));
              if (res) {
                successMessage('Product created successfully!');
                await productProvider.fetchProducts();
                Navigator.of(Get.context!).pop();
              } else {
                dangerMessage(productProvider.error!);
              }
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

//CreateManufactureProductDialog
class CreateManufactureProduct extends StatefulWidget {
  const CreateManufactureProduct({
    super.key,
  });

  @override
  State<CreateManufactureProduct> createState() =>
      _CreateManufactureProductState();
}

class _CreateManufactureProductState extends State<CreateManufactureProduct> {
  final _createProductData = {};
  List<dynamic> _selectedConstituents = [];

  @override
  void initState() {
    super.initState();
    _createProductData['constituents'] = <String, int>{};
  }

  void addToConstituents(RawMaterial rawMaterial, int quantity) {
    final data = {rawMaterial: quantity};
    setState(() {
      _selectedConstituents.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: true);

    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('New Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              margin: false,
              label: 'Name',
              isRequired: true,
              onSaved: (value) {
                _createProductData['name'] = value;
              },
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Description',
              isRequired: true,
              onSaved: (value) {
                _createProductData['desc'] = value;
              },
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Price',
              isRequired: true,
              onSaved: (value) {
                if (value != null) {
                  _createProductData['price'] = double.parse(value);
                }
              },
              inputType: const TextInputType.numberWithOptions(decimal: true),
            ),
            addVerticalSpace(20),
            LabelWidget(
              label: 'Constituents',
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddConstituentDialog(
                        addToConstituents: addToConstituents),
                  );
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.2,
              width: screenWidth * 0.2,
              child: ListView.builder(
                itemCount: _selectedConstituents.length,
                itemBuilder: (context, index) {
                  RawMaterial rawMaterial =
                      _selectedConstituents[index].keys.toList().first;
                  int quantity = _selectedConstituents[index][rawMaterial];

                  dynamic data = {
                    "name": rawMaterial.name,
                    "quantity": quantity
                  };
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(data['name']),
                        ),
                        Expanded(
                          child: Text(data['quantity'].toString()),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () => setState(() {
                        _selectedConstituents.removeAt(index);
                      }),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        actions: [
          SubmitButton(
            label: 'Create',
            onPressed: () async {
              for (Map data in _selectedConstituents) {
                RawMaterial rm = data.keys.toList().first;
                String id = rm.id!;
                int quantity = data[rm];
                _createProductData['constituents']
                    .addEntries({id: quantity}.entries);
              }

              final res = await productProvider
                  .createProduct(Product.fromJson(_createProductData));
              if (res) {
                successMessage('Product created successfully!');
                await productProvider.fetchProducts();
                Navigator.of(Get.context!).pop();
              } else {
                dangerMessage(productProvider.error!);
              }
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class AddConstituentDialog extends StatefulWidget {
  const AddConstituentDialog({super.key, required this.addToConstituents});

  final Function addToConstituents;

  @override
  State<AddConstituentDialog> createState() => _AddConstituentDialogState();
}

class _AddConstituentDialogState extends State<AddConstituentDialog> {
  RawMaterial? _dpRawMaterial;
  int? _quantity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final rawMaterialProvider =
          Provider.of<RawMaterialProvider>(context, listen: false);
      if (rawMaterialProvider.rawMaterials.isEmpty) {
        await rawMaterialProvider.fetchRawMaterials();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rawMaterialProvider = Provider.of<RawMaterialProvider>(context);
    List<RawMaterial> rmList = rawMaterialProvider.rawMaterials;

    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Add Constituent'),
        content: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: CustomDropDown<RawMaterial>(
                isLoading: rawMaterialProvider.isLoading,
                labelText: 'Raw Material',
                value: _dpRawMaterial,
                itemList: rmList,
                displayItem: (RawMaterial rawMaterial) => rawMaterial.name,
                onChanged: (RawMaterial? newValue) {
                  if (newValue != _dpRawMaterial) {
                    setState(() {
                      _dpRawMaterial = newValue!;
                    });
                  }
                },
              ),
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Quantity',
              isRequired: true,
              onSaved: (value) {
                if (value != null) {
                  _quantity = int.parse(value);
                }
              },
              inputType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TriggerButton(
            title: 'Add',
            onPressed: () {
              widget.addToConstituents(_dpRawMaterial, _quantity);

              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
