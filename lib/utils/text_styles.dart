import 'package:dlalat_quaran_new/controllers/settings_controller.dart';
import 'package:dlalat_quaran_new/ui/setting_screen.dart';
import 'package:dlalat_quaran_new/utils/calc_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

Map<String, Style> mainHtmlStyle() => {
  '#': Style(
    fontFamily: "Amiri",
    textAlign: TextAlign.justify,
    fontSize:
        Get.find<SettingsController>().fontTypeEnum == FontType.normal
            ? FontSize(calcFontSize(14))
            : FontSize(calcFontSize(18)),
    padding: HtmlPaddings(left: HtmlPadding(0), right: HtmlPadding(0)),
    margin: Margins(left: Margin(0), right: Margin(0)),
    //   color: primaryColor,
    lineHeight: LineHeight.number(1.2),
  ),
};

class DefaultText extends StatelessWidget {
  const DefaultText(this.txt, {super.key, this.fontSize = 15, this.color = Colors.black});
  final String txt;
  final double fontSize;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(txt, style: TextStyle(fontSize: fontSize, fontFamily: "Almarai", color: color));
  }
}

class ArabicText extends StatelessWidget {
  const ArabicText(
    this.txt, {
    super.key,
    this.fontSize = 17,
    this.color = Colors.black,
    this.maxLines,
    this.textAlign,
  });
  final String txt;
  final double fontSize;
  final Color color;
  final int? maxLines;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: "Amiri",
        color: color,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      ),
    );
  }
}
