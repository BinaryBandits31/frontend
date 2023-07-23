import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../providers/branch_provider.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/helper_widgets.dart';
import '../../../../widgets/notify.dart';
import '../../../../widgets/text_field.dart';

class CreateBranchDialog extends StatefulWidget {
  @override
  _CreateBranchDialogState createState() => _CreateBranchDialogState();
}

class _CreateBranchDialogState extends State<CreateBranchDialog> {
  String dropdownValue = 'RETAIL';
  final _createBranchData = {};

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    _createBranchData['type'] = dropdownValue;

    return AlertDialog(
      title: const Text('New Branch'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
            margin: false,
            label: 'Name',
            isRequired: true,
            onSaved: (value) {
              _createBranchData['name'] = value;
            },
          ),
          addVerticalSpace(20),
          DropdownButton<String>(
            alignment: AlignmentDirectional.topStart,
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
              _createBranchData['type'] = newValue;
            },
            items: <String>['RETAIL', 'WHOLESALE']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        SubmitButton(
          isLoading: branchProvider.isLoading,
          label: 'Create',
          onPressed: () async {
            final res = await branchProvider.createBranch(_createBranchData);
            if (res) {
              successMessage('Branch created successfully!');
              await branchProvider.fetchBranches();
              Navigator.of(Get.context!).pop();
            } else {
              dangerMessage(branchProvider.error!);
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
