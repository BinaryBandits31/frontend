import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.onSaved,
    this.isRequired = false,
  });

  final String label;
  final bool? isRequired;
  final void Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(sH(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: sH(15),
              color: AppColor.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty && isRequired!) {
                return '$label is required';
              }
              return null;
            },
            onChanged: onSaved,
          ),
        ],
      ),
    );
  }
}
