import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';

Color _primaryColor = AppColor.orange3;
// Color _secondaryColor =

ThemeData darkTheme = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  cardTheme: CardTheme(
    color: AppColor.black1,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: _primaryColor.withOpacity(0.7),
    selectionHandleColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorStyle: const TextStyle(color: Colors.red),
    errorBorder:
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: _primaryColor),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    labelStyle: TextStyle(color: AppColor.grey1),
  ),
);
