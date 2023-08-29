import 'package:flutter/material.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/helper_widgets.dart';
import '../../../../widgets/notify.dart';
import '../../../../widgets/text_field.dart';

class CreateProductDialog extends StatefulWidget {
  @override
  _CreateProductDialogState createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  final _createProductData = {}; // Data to hold the input fields

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    _createProductData['quantity'] = 0;

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