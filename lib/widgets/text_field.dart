import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField(
      {super.key,
      required this.label,
      required this.onSaved,
      this.isRequired = false,
      this.margin = true,
      this.initialValue = '',
      this.inputType});

  final String label;
  final bool? isRequired;
  final void Function(String?) onSaved;
  final bool margin;
  final String initialValue;
  final TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ? EdgeInsets.all(sH(10)) : const EdgeInsets.all(0),
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
            obscureText: label == 'Password' ? true : false,
            initialValue: initialValue,
            validator: (value) {
              if (value!.isEmpty && isRequired!) {
                return '$label is required';
              }
              return null;
            },
            onChanged: onSaved,
            keyboardType: inputType,
          ),
        ],
      ),
    );
  }
}
