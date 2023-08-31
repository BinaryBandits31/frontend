import 'package:flutter/material.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/models/raw_material.dart';
import 'package:frontend/pages/app/admin/users/create_user_dialog.dart';
import 'package:frontend/providers/raw_material_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/helper_widgets.dart';
import '../../../../widgets/notify.dart';
import '../../../../widgets/text_field.dart';

const List<String> kPackageTypes = [
  "CARTON",
  "BAG",
  "PACKET",
  "DRUM",
  "OTHER",
];

const List<String> kBaseUnits = [
  "KG",
  "G",
  "LITRES",
  "ML",
  "ITEM",
  "OTHER",
];

class CreateRMDialog extends StatefulWidget {
  @override
  _CreateRMDialogState createState() => _CreateRMDialogState();
}

class _CreateRMDialogState extends State<CreateRMDialog> {
  final _createRMData = {}; // Data to hold the input fields
  String? dpPackage = kPackageTypes[0];
  String? dpBaseUnit;

  @override
  Widget build(BuildContext context) {
    final rawMaterialProvider =
        Provider.of<RawMaterialProvider>(context, listen: true);
    _createRMData['packType'] = dpPackage;

    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('New Raw Material'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              margin: false,
              label: 'Name',
              isRequired: true,
              onSaved: (value) {
                _createRMData['name'] = value;
              },
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Description',
              isRequired: true,
              onSaved: (value) {
                _createRMData['desc'] = value;
              },
            ),
            addVerticalSpace(20),
            LabelWidget(
              label: 'Package',
              child: DropdownButton<String>(
                alignment: AlignmentDirectional.topStart,
                value: dpPackage,
                onChanged: (String? newValue) {
                  setState(() {
                    dpPackage = newValue!;
                  });
                  _createRMData['packType'] = newValue;
                },
                items:
                    kPackageTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            addVerticalSpace(20),
            LabelWidget(
              label: 'Base Unit',
              child: DropdownButton<String>(
                alignment: AlignmentDirectional.topStart,
                value: dpBaseUnit,
                onChanged: (String? newValue) {
                  setState(() {
                    dpBaseUnit = newValue!;
                  });
                  _createRMData['packUnit'] = newValue;
                },
                items: kBaseUnits.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Qty Per Pack',
              isRequired: true,
              onSaved: (value) {
                if (value != null) {
                  _createRMData['unitsPerPack'] = double.parse(value);
                }
              },
              inputType: const TextInputType.numberWithOptions(decimal: true),
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Price',
              isRequired: true,
              onSaved: (value) {
                if (value != null) {
                  _createRMData['pricePerPack'] = double.parse(value);
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
              final res = await rawMaterialProvider
                  .createRawMaterial(RawMaterial.fromJson(_createRMData));
              if (res) {
                successMessage('Raw Material created successfully!');
                await rawMaterialProvider.fetchRawMaterials();
                Navigator.of(Get.context!).pop();
              } else {
                dangerMessage(rawMaterialProvider.error!);
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
