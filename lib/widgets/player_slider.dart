import 'package:audioplayers/audioplayers.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/ui/new_single_sura_screen.dart';
import 'package:dlalat_quaran_new/ui/player_bottom_widget.dart';
import 'package:dlalat_quaran_new/ui/short_explanation_index.dart';
import 'package:dlalat_quaran_new/ui/sura_en_screen.dart';
import 'package:dlalat_quaran_new/utils/audio_folders.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class PlayerSlider extends StatefulWidget {
  int currentValue;

  int maxValue;

  void Function(double)? onSeekChange;

  PlayerSlider(
      {super.key,
      required this.currentValue,
      required this.maxValue,
      required this.onSeekChange});

  void setPosition(int position) {}

  @override
  _PlayerSliderState createState() => _PlayerSliderState();
}

class _PlayerSliderState extends State<PlayerSlider> {
  void reset() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
      width: double.infinity,
      child: SliderTheme(
        data: const SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
        child: Slider(
            inactiveColor: lightGray,
            activeColor: primaryColor2,
            thumbColor: primaryColor,
            value: widget.currentValue.toDouble(),
            onChanged: (value) async {
              setState(() {
                widget.currentValue = value.toInt();
                selectAyaNo.value = value.toInt().toString();

                if (GetStorage().read(language) != null &&
                    GetStorage().read(language) == 'en') {}
              });
            },
            onChangeEnd: (value) async {
              if (widget.onSeekChange != null) {
                widget.onSeekChange!(value);
              } else {
                await audioPlayer.stop();
                var s = await DataBaseHelper.dataBaseInstance()
                    .getAyaId(playerSuraId.value, value.toInt());
                // setState(() {
                selectedAyaId.value = s.toString();
                var i = value.toInt();
                selectAyaNo.value = i.toString();
                selectedAyaId.value =
                    (int.parse(selectedAyaId.value)).toString();

                currentPage.value = await DataBaseHelper.dataBaseInstance()
                        .getAyaPage(selectedAyaId.value) -
                    1;

                String newPath = await AudioFolders().generatePath(
                    currentReciter.value,
                    playerSuraId.value.toString(),
                    selectAyaNo.value.toString());

                audioPlayer.play(DeviceFileSource(newPath));
                if (parentWidget != null) {
                  if (parentWidget!.mounted) {
                    parentWidget!.setState(() {});
                  }
                }
              }

              if (autoScrollController != null) {
                autoScrollController!
                    .scrollToIndex(int.parse(selectAyaNo.value) - 1);
                suraEnController.update();
              }

              // });
            },
            label: 'الآيه ${widget.currentValue.toInt()}',
            divisions:
                widget.maxValue != 1 ? widget.maxValue - 1 : widget.maxValue,
            min: 1,
            max: widget.maxValue.toDouble()),
      ),
    );
  }
}
