import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/custom_widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../providers/branch_provider.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/helper_widgets.dart';
import '../../../../widgets/notify.dart';
import '../../../../widgets/text_field.dart';

class CreateNewUserDialog extends StatefulWidget {
  @override
  _CreateNewUserDialogState createState() => _CreateNewUserDialogState();
}

class _CreateNewUserDialogState extends State<CreateNewUserDialog> {
  String dpEmpLevel = '1';
  Branch? dpEmpBranch;
  DateTime? _selectedDOB;
  final _createNewUserData = {};

  void _handleDOBDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDOB = selectedDate;
    });
    _createNewUserData['dob'] = DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final branchProvider =
          Provider.of<BranchProvider>(context, listen: false);
      if (branchProvider.branches.isEmpty) {
        await branchProvider.fetchBranches();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context, listen: true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _createNewUserData['emp_Type'] = 'CASHIER';
    _createNewUserData['emp_Level'] = int.parse(dpEmpLevel);

    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Create New User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              margin: false,
              label: 'First Name',
              isRequired: true,
              onSaved: (value) {
                _createNewUserData['first_Name'] = value;
              },
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Last Name',
              isRequired: true,
              onSaved: (value) {
                _createNewUserData['last_Name'] = value;
              },
            ),
            addVerticalSpace(20),
            LabeledTextField(
              margin: false,
              label: 'Username',
              isRequired: true,
              onSaved: (value) {
                _createNewUserData['username'] = value;
              },
            ),
            addVerticalSpace(20),
            LabelWidget(
              label: 'DOB:',
              child: CustomDOBDatePicker(
                selectedDate: _selectedDOB,
                onDateSelected: _handleDOBDateSelected,
              ),
            ),
            addVerticalSpace(20),
            LabelWidget(
              label: 'Employee Level',
              child: DropdownButton<String>(
                alignment: AlignmentDirectional.topStart,
                value: dpEmpLevel,
                onChanged: (String? newValue) {
                  setState(() {
                    dpEmpLevel = newValue!;
                  });
                  _createNewUserData['emp_Level'] = int.parse(newValue!);
                },
                items: <String>['1', '2', '3']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            addVerticalSpace(20),
            LabelWidget(
              label: 'Branch',
              child: DropdownButton<Branch>(
                alignment: AlignmentDirectional.topStart,
                value: dpEmpBranch,
                onChanged: (Branch? newValue) {
                  setState(() {
                    dpEmpBranch = newValue!;
                  });
                  _createNewUserData['branch_Id'] = newValue?.branchID;
                },
                items: branchProvider.branches
                    .map<DropdownMenuItem<Branch>>((Branch value) {
                  return DropdownMenuItem<Branch>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        actions: [
          SubmitButton(
            label: 'Create',
            onPressed: () async {
              final res = await userProvider.createNewUser(_createNewUserData);
              if (res) {
                successMessage('User created successfully!');
                userProvider.fetchFellowUsers();
                Navigator.of(Get.context!).pop();
              } else {
                dangerMessage(userProvider.createUserError!);
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

class LabelWidget extends StatelessWidget {
  final String label;
  final Widget child;
  const LabelWidget({super.key, required this.child, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: sH(16), fontWeight: FontWeight.bold),
        ),
        child
      ],
    );
  }
}
