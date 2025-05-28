import 'package:dlalat_quaran_new/controllers/audio_recitation_controller.dart';
import 'package:dlalat_quaran_new/models/sura_model.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:flutter/material.dart';

class SuraSpinner extends StatefulWidget {
  late AudioRecitationController controller;

  SuraSpinner(this.controller, {super.key});

  @override
  _SuraSpinnerState createState() => _SuraSpinnerState();
}

class _SuraSpinnerState extends State<SuraSpinner> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<SuraModel?>(
      value: widget.controller.selectedSura.value,
      items: widget.controller.surasList.value
          .map<DropdownMenuItem<SuraModel?>>((SuraModel? value) {
        return DropdownMenuItem<SuraModel?>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: AlMaraiText(0, value!.toString()),
          ),
        );
      }).toList(),
      onChanged: (value) {
        Future.delayed(Duration.zero, () async {
          setState(() {
            widget.controller.audioPlayer!.release();
            widget.controller.selectedSura.value = value!;
            widget.controller.selectAya.value = '1';
            widget.controller.suraId.value =
                widget.controller.selectedSura.value.id!;
            widget.controller
                .getSuraAyat(widget.controller.selectedSura.value.id!);
            widget.controller.update();
          });
        });
      },
      isExpanded: true,
      underline: const SizedBox(),
    );
  }
}
