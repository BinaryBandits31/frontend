import 'package:flutter/material.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/helper_widgets.dart';
import '../../../../widgets/notify.dart';
import '../../../../widgets/text_field.dart';

class EditProductDialog extends StatefulWidget {
  final Product product;

  const EditProductDialog(this.product, {super.key});

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _editProductData = {};
  bool isLoading = false;

  void toggleLoad() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    return AlertDialog(
      title: const Text('Edit Branch'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
            initialValue: widget.product.name,
            margin: false,
            label: 'Name',
            isRequired: true,
            onSaved: (value) {
              _editProductData['name'] = value;
            },
          ),
          addVerticalSpace(20),
          LabeledTextField(
            initialValue: widget.product.description,
            margin: false,
            label: 'Description',
            isRequired: true,
            onSaved: (value) {
              _editProductData['desc'] = value;
            },
          ),
          addVerticalSpace(20),
          LabeledTextField(
            initialValue: widget.product.price.toString(),
            margin: false,
            label: 'Price',
            isRequired: true,
            onSaved: (value) {
              if (value != null) {
                _editProductData['price'] = double.parse(value);
              }
            },
            inputType: const TextInputType.numberWithOptions(decimal: true),
          ),
          addVerticalSpace(20),
          LabeledTextField(
            initialValue: widget.product.quantity.toString(),
            margin: false,
            label: 'Quantity',
            isRequired: true,
            onSaved: (value) {
              if (value != null) {
                _editProductData['quantity'] = int.parse(value);
              }
            },
            inputType: TextInputType.number,
          )
        ],
      ),
      actions: [
        SubmitButton(
          label: 'Edit',
          onPressed: () async {
            toggleLoad();
            final res = await productProvider
                .editProduct(Product.fromJson(_editProductData));
            if (res) {
              successMessage('Product edited successfully!');
              await productProvider.fetchProducts();
              Navigator.of(Get.context!).pop();
            } else {
              dangerMessage(productProvider.error!);
            }
            toggleLoad();
          },
        ),
        TextButton(
          onPressed: () {
            if (isLoading == false) {
              Navigator.of(Get.context!).pop();
            }
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
