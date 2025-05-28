import 'package:flutter/material.dart';

class DefaultScreenPadding extends StatelessWidget {
  const DefaultScreenPadding({super.key, required this.child, this.paddingParam});
  final Widget child;
  static final EdgeInsets padding = EdgeInsets.symmetric(vertical: 5, horizontal: 10);
  final EdgeInsets? paddingParam;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: paddingParam ?? padding, child: child);
  }
}
