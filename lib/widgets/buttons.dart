import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.isLoading});

  final String label;
  final bool isLoading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColor.orange3),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            )),
        onPressed: onPressed,
        child: Stack(
          children: [
            Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !isLoading ? AppColor.black1 : Colors.transparent,
                  fontSize: sH(18)),
            ),
            isLoading
                ? Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: sH(18),
                        width: sH(18),
                        child: const CircularProgressIndicator(
                            strokeWidth: 3, color: Colors.black),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ));
  }
}
