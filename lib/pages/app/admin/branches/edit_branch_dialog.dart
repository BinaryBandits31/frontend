import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../models/branch.dart';
import '../../../../providers/branch_provider.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/helper_widgets.dart';
import '../../../../widgets/notify.dart';
import '../../../../widgets/text_field.dart';

class EditBranchDialog extends StatefulWidget {
  final Branch branch;

  const EditBranchDialog(this.branch, {super.key});

  @override
  _EditBranchDialogState createState() => _EditBranchDialogState();
}

class _EditBranchDialogState extends State<EditBranchDialog> {
  final _editBranchData = {};
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      dropdownValue = widget.branch.type;
    });
  }

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);

    _editBranchData['branchID'] = widget.branch.branchID;

    return AlertDialog(
      title: const Text('Edit Branch'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
            initialValue: widget.branch.name,
            margin: false,
            label: 'Name',
            isRequired: true,
            onSaved: (value) {
              _editBranchData['name'] = value;
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
              _editBranchData['type'] = newValue;
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
            final res = await branchProvider.editBranch(_editBranchData);
            if (res) {
              successMessage('Branch edited successfully!');
              await branchProvider.fetchBranches();
              Navigator.of(context).pop();
            } else {
              dangerMessage(branchProvider.error!);
            }
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.of(Get.context!).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
