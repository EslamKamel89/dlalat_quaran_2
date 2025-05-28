import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double borderRadius;

  const PrimaryButton(
      {super.key,
      required this.onPressed,
      required this.child,
      required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius == 0 ? 10 : borderRadius)))),
      child: child,
    );
  }
}
