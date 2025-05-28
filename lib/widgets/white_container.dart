import 'package:flutter/material.dart';

class WhiteContainer extends StatelessWidget {
  double height;
  double radius;
  Widget child;

  WhiteContainer(
      {Key? key,
      required this.height,
      required this.radius,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      child: child,
    );
  }
}
