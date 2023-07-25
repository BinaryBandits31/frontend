import 'package:flutter/material.dart';

import '../utils/constants.dart';

class BigText extends StatelessWidget {
  const BigText(
    this.text, {
    this.color = const Color(0xFFFDFCFD),
    this.size,
    this.overflow = TextOverflow.ellipsis,
    super.key,
  });

  final String? text;
  final Color color;
  final double? size;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: size != null ? sH(size!) : sH(40),
        // color: color,
      ),
    );
  }
}
