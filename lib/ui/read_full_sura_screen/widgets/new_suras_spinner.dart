import 'package:dlalat_quaran_new/controllers/read_full_surah_controller.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewSurasSpinner extends StatefulWidget {
  const NewSurasSpinner({super.key});

  @override
  NewSurasSpinnerState createState() => NewSurasSpinnerState();
}

class NewSurasSpinnerState extends State<NewSurasSpinner> {
  ReadFullSurahController readSuraController = Get.find<ReadFullSurahController>();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SuraInfoModel>(
      value: readSuraController.selectedSuraModel,
      items: readSuraController.suraInfoModels.map<DropdownMenuItem<SuraInfoModel>>((SuraInfoModel sura) {
        return DropdownMenuItem<SuraInfoModel>(
          value: sura,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: AlMaraiText(0, sura.sura_ar),
          ),
        );
      }).toList(),
      onChanged: (value) async {
        if (value != null) {
          await readSuraController.resetAudioPlayer();
          readSuraController.stopPlaying = true;
          readSuraController.selectSura(value);
          readSuraController.selectedAyaValue = null;
          setState(() {});
        }
      },
      isExpanded: true,
      underline: const SizedBox(),
    );
  }
}
