import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.danger,
  });

  final String label;
  final Function() onPressed;
  final bool? danger;

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
    bool danger = widget.danger ?? false;
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                !danger ? AppColor.orange3 : Colors.red),
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
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class HorizontalToggleButton extends StatefulWidget {
  @override
  _HorizontalToggleButtonState createState() => _HorizontalToggleButtonState();
}

class _HorizontalToggleButtonState extends State<HorizontalToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOption1Selected = true; // Initial selection

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleOption() {
    setState(() {
      _isOption1Selected = !_isOption1Selected;
    });
    if (_isOption1Selected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleOption,
      child: Container(
        width: 120, // Adjust the width as per your requirement
        height: 40, // Adjust the height as per your requirement
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[400],
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  left: _isOption1Selected
                      ? 0
                      : (120 -
                          40), // Adjust the distance to move left based on width of container
                  child: Container(
                    width:
                        60, // Adjust the width of the toggle button as per your requirement
                    height: 40, // Adjust the height as per your requirement
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        _isOption1Selected ? 'Option 1' : 'Option 2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
