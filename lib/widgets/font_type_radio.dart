import 'package:dlalat_quaran_new/controllers/settings_controller.dart';
import 'package:dlalat_quaran_new/ui/setting_screen.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FontTypeRadio extends StatefulWidget {
  SettingsController controller;

  FontTypeRadio(this.controller, {super.key});

  @override
  State<FontTypeRadio> createState() => _FontTypeRadioState();
}

class _FontTypeRadioState extends State<FontTypeRadio> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Flexible(
              flex: 1,
              child: ListTileTheme(
                horizontalTitleGap: .5,
                child: ListTile(
                  title: AlMaraiText(14, 'normal'.tr),
                  leading: Radio<FontType>(
                    value: FontType.normal,
                    groupValue: widget.controller.fontTypeEnum,
                    onChanged: (FontType? value) {
                      setState(() {
                        // widget.controller.fontType = FontType.normal;
                        // widget.controller.mFontType.value = FontType.normal.name;
                        widget.controller.changeFontType(FontType.normal);
                      });
                      // widget.controller.update();
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: ListTileTheme(
                horizontalTitleGap: 1,
                child: ListTile(
                  title: Text(
                    'bold'.tr,
                    style:
                        const TextStyle(fontFamily: 'Almarai', height: 1.5, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  leading: Radio<FontType>(
                    value: FontType.bold,
                    groupValue: widget.controller.fontTypeEnum,
                    onChanged: (FontType? value) {
                      setState(() {
                        // widget.controller.fontType = FontType.bold;
                        // widget.controller.mFontType.value = FontType.bold.name;
                        widget.controller.changeFontType(FontType.bold);
                      });
                      // widget.controller.update();
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
