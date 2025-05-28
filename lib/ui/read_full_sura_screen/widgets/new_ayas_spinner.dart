import 'package:dlalat_quaran_new/controllers/read_full_surah_controller.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewAyasSpinner extends StatefulWidget {
  const NewAyasSpinner({super.key});

  @override
  NewAyasSpinnerState createState() => NewAyasSpinnerState();
}

class NewAyasSpinnerState extends State<NewAyasSpinner> {
  ReadFullSurahController controller = Get.find<ReadFullSurahController>();
  // int selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    // return const SizedBox();

    return GetBuilder<ReadFullSurahController>(builder: (_) {
      if (controller.selectedSuraModel == null) {
        return const SizedBox();
      }
      int numberOfAyas;
      if (controller.suraIndex == controller.suraInfoModels.length - 1) {
        numberOfAyas = 6;
      } else {
        numberOfAyas = controller.suraInfoModels[controller.suraIndex + 1].start - controller.selectedSuraModel!.start;
      }
      // pr(numberOfAyas, 'numberOfAyas');
      // pr(controller.suraIndex, 'suraIndex');

      return DropdownButton<int>(
        // value: controller.ayaId,
        value: controller.selectedAyaValue,
        items: List.generate(numberOfAyas, (index) => index).map<DropdownMenuItem<int>>((int id) {
          controller.selectedSuraModel!.start + id;
          return DropdownMenuItem<int>(
            value: controller.selectedSuraModel!.start + id,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: DefaultText("  الأية رقم ${id + 1}"),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.stopPlaying = true;
            controller.resetAudioPlayer();
            controller.ayaId = value;
            controller.selectedAyaValue = value;
            setState(() {});
          }
        },
        isExpanded: true,
        underline: const SizedBox(),
      );
    });
  }
}
