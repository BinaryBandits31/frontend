import 'package:flutter/material.dart';
import 'package:frontend/models/raw_material.dart';
import 'package:frontend/pages/app/admin/users/create_user_dialog.dart';
import 'package:frontend/providers/raw_material_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/buttons.dart';
import '../../../../widgets/helper_widgets.dart';
import '../../../../widgets/notify.dart';
import '../../../../widgets/text_field.dart';

class AddRawMaterialDialog extends StatefulWidget {
  final RawMaterial rawMaterial;

  const AddRawMaterialDialog(this.rawMaterial, {super.key});

  @override
  _AddRawMaterialDialogState createState() => _AddRawMaterialDialogState();
}

class _AddRawMaterialDialogState extends State<AddRawMaterialDialog> {
  bool isLoading = false;
  final _addRawMaterialData = {};
  List<String> _packageUnits = [];
  String? _packageValue;
  int? _quantity;

  @override
  void initState() {
    super.initState();
    setState(() {
      _packageUnits = [
        widget.rawMaterial.package,
        widget.rawMaterial.baseUnit,
      ];
      _packageValue = _packageUnits[0];
    });
  }

  void toggleLoad() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rawMaterialProvider =
        Provider.of<RawMaterialProvider>(context, listen: false);
    _addRawMaterialData['id'] = widget.rawMaterial.id;
    _addRawMaterialData["packUnit"] = _packageValue;

    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Add Raw Material'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              isEditable: false,
              initialValue: widget.rawMaterial.name,
              margin: false,
              label: 'Raw Material',
              isRequired: true,
              onSaved: (value) {
                _addRawMaterialData['name'] = value;
              },
            ),
            addVerticalSpace(20),
            LabelWidget(
              label: 'Package',
              child: DropdownButton<String>(
                alignment: AlignmentDirectional.topStart,
                value: _packageValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _packageValue = newValue!;
                  });
                  _addRawMaterialData['packUnit'] = newValue;
                },
                items:
                    _packageUnits.map<DropdownMenuItem<String>>((String value) {
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
          SubmitButton(
            label: 'Add',
            onPressed: () async {
              toggleLoad();
              if (_packageUnits.indexOf(_packageValue!) == 0) {
                _addRawMaterialData['numberOfPacks'] = _quantity;
                _addRawMaterialData['numberOfUnits'] = 0;
              } else {
                _addRawMaterialData['numberOfPacks'] = 0;
                _addRawMaterialData['numberOfUnits'] = _quantity;
              }

              _addRawMaterialData['branch_Id'] =
                  rawMaterialProvider.selectedBranch!.branchID;

              final res = await rawMaterialProvider
                  .addRawMaterialStock(_addRawMaterialData);
              if (res) {
                successMessage('Raw Material Added Successfully!');
                await rawMaterialProvider.fetchRawMaterials();
                Navigator.of(Get.context!).pop();
              } else {
                dangerMessage(rawMaterialProvider.error!);
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
      ),
    );
  }
}
