import 'package:flutter/material.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class AlMaraiText extends StatelessWidget {
  double fontSize = 14;

  String contentBody;

  AlMaraiText(this.fontSize, this.contentBody, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      contentBody,
      textScaleFactor: 1.0,
      style: TextStyle(
          fontFamily: 'Almarai',
          height: 1.5,
          fontSize: fontSize == 0.0 ? 14 : fontSize),
    );
  }
} // ignore: must_be_immutable

class AlMaraiTextBottom extends StatelessWidget {
  double fontSize = 14;

  String contentBody;

  AlMaraiTextBottom(this.fontSize, this.contentBody, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      contentBody,
      textScaleFactor: 1.0,
      style: TextStyle(
          fontFamily: 'Almarai',
          height: 1.5,
          color: primaryColor2, //Colors.white,
          fontSize: fontSize == 0.0 ? 14 : fontSize),
    );
  }
}
