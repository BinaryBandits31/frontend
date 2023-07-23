import 'package:flutter/material.dart';
import 'package:frontend/providers/supplier_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/helper_widgets.dart';
import '../../../../widgets/notify.dart';
import '../../../../widgets/text_field.dart';

class CreateSupplierDialog extends StatefulWidget {
  @override
  _CreateSupplierDialogState createState() => _CreateSupplierDialogState();
}

class _CreateSupplierDialogState extends State<CreateSupplierDialog> {
  final _createSupplierData = {};

  @override
  Widget build(BuildContext context) {
    final supplierProvider =
        Provider.of<SupplierProvider>(context, listen: false);

    return AlertDialog(
      title: const Text('New Supplier'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              margin: false,
              label: 'Name',
              isRequired: true,
              onSaved: (value) {
                _createSupplierData['name'] = value;
              },
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Email',
              isRequired: true,
              onSaved: (value) {
                _createSupplierData['email'] = value;
              },
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Phone',
              isRequired: true,
              onSaved: (value) {
                _createSupplierData['phone'] = value;
              },
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Address',
              isRequired: true,
              onSaved: (value) {
                _createSupplierData['address'] = value;
              },
            ),
            addVerticalSpace(20),
          ],
        ),
      ),
      actions: [
        SubmitButton(
          isLoading: supplierProvider.isLoading,
          label: 'Create',
          onPressed: () async {
            final res =
                await supplierProvider.createSupplier(_createSupplierData);
            if (res) {
              successMessage('Branch created successfully!');
              await supplierProvider.fetchSuppliers();
              Navigator.of(Get.context!).pop();
            } else {
              dangerMessage(supplierProvider.error!);
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
    );
  }
}
