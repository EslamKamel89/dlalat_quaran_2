import 'package:dlalat_quaran_new/controllers/audio_recitation_controller.dart';
import 'package:dlalat_quaran_new/models/reciters_model.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class RecitersSpinner extends StatefulWidget {
  late AudioRecitationController controller;

  RecitersSpinner(this.controller, {super.key});

  @override
  _RecitersSpinnerState createState() => _RecitersSpinnerState();
}

class _RecitersSpinnerState extends State<RecitersSpinner> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<ReciterModel?>(
      value: widget.controller.selectedReciter.value,
      items: widget.controller.recitersList
          .map<DropdownMenuItem<ReciterModel?>>((ReciterModel? value) {
        return DropdownMenuItem<ReciterModel?>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: AlMaraiText(0, value!.toString()),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          GetStorage().write(reciterKey, value!.id.toString());
          widget.controller.selectedReciter.value = value;
          widget.controller.update();
        });
      },
      isExpanded: true,
      underline: const SizedBox(),
    );
  }
}
