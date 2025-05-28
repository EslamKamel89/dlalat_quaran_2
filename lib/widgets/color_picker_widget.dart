// ignore_for_file: use_key_in_widget_constructors

import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:flutter/material.dart';

import '../controllers/settings_controller.dart';
import '../utils/constants.dart';

class ColorPickerWidget extends StatelessWidget {
  final String tilte;

  final SettingsController controller;
  final String type;

  const ColorPickerWidget(
      {required this.tilte, required this.type, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              tilte,
              style: const TextStyle(fontFamily: 'Almarai'),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              height: 35,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white),
              child: ColorsSpinner(controller, type),
            ),
          )
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
class ColorsSpinner extends StatefulWidget {
  late SettingsController controller;
  // late Color selectedColor;
  late String type;
  ColorsSpinner(this.controller, this.type, {super.key});

  @override
  _LanguageSpinnerState createState() => _LanguageSpinnerState();
}

class _LanguageSpinnerState extends State<ColorsSpinner> {
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case KpageBg:
        selectedColor = colors[widget.controller.pageBg.value];
        break;
      case KnormalFontColor:
        selectedColor = colors[widget.controller.normalFontColor.value];
        break;
      case KtagWordsColor:
        selectedColor = colors[widget.controller.tagWordsColor.value];
        break;
      case KreadWordsColor:
        selectedColor = colors[widget.controller.readWordsColor.value];
        break;
    }
    return DropdownButton<Color?>(
      value: selectedColor,
      items: colors.map<DropdownMenuItem<Color?>>((Color? value) {
        return DropdownMenuItem<Color?>(
          value: value,
          child: Container(
            decoration: BoxDecoration(
                color: value!,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: primaryColor, width: 1)),
            margin: const EdgeInsets.all(3),
          ),
        );
      }).toList(),
      onChanged: (value) {
        selectedColor = value!;
        switch (widget.type) {
          case KpageBg:
            widget.controller.setPageBg(colors.indexOf(value));
            break;
          case KnormalFontColor:
            widget.controller.setNormalFont(colors.indexOf(value));
            break;
          case KtagWordsColor:
            widget.controller.setTagWordsColor(colors.indexOf(value));
            break;
          case KreadWordsColor:
            widget.controller.setReadingColor(colors.indexOf(value));
            break;
        }
        setState(() {
          Container(
            decoration: BoxDecoration(
                color: selectedColor!,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: primaryColor, width: 3)),
          );
        });
      },
      isExpanded: true,
      underline: const SizedBox(),
    );
  }
}
