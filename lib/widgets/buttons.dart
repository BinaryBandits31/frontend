import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final Function() onPressed;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isLoading = false;

  void toggleLoad() {
    setState(() {
      isLoading = !isLoading;
    });
  }

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
        onPressed: () async {
          if (!isLoading) {
            toggleLoad();
            await widget.onPressed();
            toggleLoad();
          }
        },
        child: Stack(
          children: [
            Text(
              widget.label,
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

class TriggerButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final bool isActive;

  const TriggerButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
              isActive ? Colors.blue : Colors.blue.shade200),
          minimumSize: MaterialStatePropertyAll(Size(sW(130), sH(40)))),
      onPressed: isActive ? onPressed : null,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
