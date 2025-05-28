import 'package:audioplayers/audioplayers.dart';
import 'package:dlalat_quaran_new/controllers/audio_recitation_controller.dart';
import 'package:dlalat_quaran_new/utils/audio_download.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/audio_folders.dart';
import 'font_text.dart';

class AudioRecitationPlayer extends StatelessWidget {
  late final AudioRecitationController _controller;

  AudioRecitationPlayer(this._controller, {super.key});
  final String _locale = GetStorage().read(language);

  void changeAya(double newValue) async {
    await _controller.audioPlayer!.stop();
    _controller.selectAya.value = (newValue.toInt()).toString();
    AudioDownload().suraDownloadPlay(
      _controller.suraId.value,
      int.parse(_controller.selectAya.value),
      _controller.selectedSuraAyatCount.value,
      _controller.audioPlayer!,
    );

    _controller.update();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSmallScreen ? Get.height / 8 : Get.height / 6,
      margin: const EdgeInsets.only(left: 7, right: 7),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 5 : 8),
            child: Row(
              // Title Row
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: lightGray2,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  height: 25,
                  width: 25,
                  child: Image.asset(logoSmall),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'reciterName'.tr,
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Almarai',
                        fontSize: 10,
                      ),
                    ),
                    Row(
                      // القارئ
                      children: [
                        // TODO Error
                        Obx(
                          () => _controller.selectedReciter.value.id != 0
                              ? AlMaraiText(
                                  isSmallScreen ? 13 : 15,
                                  _controller.selectedReciter.value.id != 0
                                      ? _controller.selectedReciter.value.toString()
                                      : '1',
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(
            () => ReciterPlayerSlider(
              currentValue: int.parse(_controller.selectAya.value),
              maxValue: _controller.selectedSuraAyatCount.value,
              onSeekChange: (p0) => changeAya(p0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  await _controller.audioPlayer!.stop();

                  if (int.parse(_controller.selectAya.value) <
                      _controller.selectedSuraAyatCount.value) {
                    // initPlayer();
                  }

                  if (int.parse(_controller.selectAya.value) > 1) {
                    var next = int.parse(_controller.selectAya.value) - 1;
                    _controller.selectAya.value = next.toString();
                    var ayaPath = await AudioFolders().generatePath(
                      _controller.selectedReciter.value.id.toString(),
                      _controller.suraId.value.toString(),
                      _controller.selectAya.value,
                    );
                    await _controller.audioPlayer!.stop();
                    await _controller.audioPlayer!.play(DeviceFileSource(ayaPath));
                  } else {
                    await _controller.audioPlayer!.stop();
                  }

                  // if (int.parse(_controller.selectAya.value) > 1) {
                  //   _controller.selectAya.value =
                  //       (int.parse(_controller.selectAya.value) - 1).toString();
                  // }
                  // var next = int.parse(_controller.selectAya.value);
                  // _controller.selectAya.value = next.toString();
                  // var ayaPath = await AudioFolders().generatePath(
                  //     _controller.selectedReciter.value.id.toString(),
                  //     _controller.suraId.value.toString(),
                  //     _controller.selectAya.value);
                  //
                  // _controller.audioPlayer!.stop();
                  //
                  // _controller.audioPlayer!.play(DeviceFileSource(ayaPath));
                },
                customBorder: const CircleBorder(),
                child: Image.asset(
                  _locale == 'ar'
                      ? 'assets/icons/ic_rewind_forward.png'
                      : 'assets/icons/ic_rewind_back.png',
                  height: isSmallScreen ? 15 : 20,
                  width: isSmallScreen ? 15 : 20,
                ),
              ),
              SizedBox(width: Get.width / 7),
              InkWell(
                onTap: () async {
                  switch (_controller.playerState) {
                    case PlayerState.stopped:
                      var link = await AudioFolders().generatePath(
                        _controller.selectedReciter.value.id.toString(),
                        _controller.suraId.value.toString(),
                        _controller.selectAya.value.toString(),
                      );
                      await _controller.audioPlayer!.stop();
                      _controller.audioPlayer!.play(DeviceFileSource(link));
                      _controller.isPlaying.value = true;
                      _controller.update();
                      break;
                    case PlayerState.playing:
                      _controller.audioPlayer!.pause();
                      _controller.isPlaying.value = false;
                      _controller.update();

                      break;
                    case PlayerState.paused:
                      _controller.audioPlayer!.resume();
                      _controller.isPlaying.value = false;
                      _controller.update();
                      break;
                    case PlayerState.completed:
                      _controller.isPlaying.value = false;
                      _controller.update();
                      break;
                    case PlayerState.disposed:
                      // TODO: Handle this case.
                      throw UnimplementedError();
                  }
                },
                customBorder: const CircleBorder(),
                child: Obx(
                  () => Image.asset(
                    _controller.isPlaying.value
                        ? 'assets/icons/ic_pause.png'
                        : 'assets/icons/ic_player_play.png',
                    height: isSmallScreen ? 15 : 20,
                    width: isSmallScreen ? 15 : 20,
                  ),
                ),
              ),
              SizedBox(width: Get.width / 7),
              InkWell(
                onTap: () async {
                  await _controller.audioPlayer!.stop();

                  if (int.parse(_controller.selectAya.value) <
                      _controller.selectedSuraAyatCount.value) {
                    // initPlayer();
                  }
                  if (int.parse(_controller.selectAya.value) <=
                      _controller.selectedSuraAyatCount.value) {
                    var next = int.parse(_controller.selectAya.value) + 1;
                    _controller.selectAya.value = next.toString();
                    var ayaPath = await AudioFolders().generatePath(
                      _controller.selectedReciter.value.id.toString(),
                      _controller.suraId.value.toString(),
                      _controller.selectAya.value,
                    );
                    await _controller.audioPlayer!.stop();
                    await _controller.audioPlayer!.play(DeviceFileSource(ayaPath));
                  } else {
                    await _controller.audioPlayer!.stop();
                  }

                  // if (int.parse(_controller.selectAya.value) <
                  //     _controller.selectedSuraAyatCount.value) {
                  //   _controller.selectAya.value =
                  //       (int.parse(_controller.selectAya.value) + 1).toString();
                  // }
                  // var link = await AudioFolders().generatePath(
                  //     _controller.selectedReciter.value.id.toString(),
                  //     _controller.suraId.value.toString(),
                  //     _controller.selectAya.value.toString());
                  //
                  // await _controller.audioPlayer!.play(DeviceFileSource(link));
                },
                customBorder: const CircleBorder(),
                child: Image.asset(
                  _locale == 'ar'
                      ? 'assets/icons/ic_rewind_back.png'
                      : 'assets/icons/ic_rewind_forward.png',
                  height: isSmallScreen ? 15 : 20,
                  width: isSmallScreen ? 15 : 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ReciterPlayerSlider extends StatefulWidget {
  int currentValue;

  int maxValue;

  void Function(double)? onSeekChange;

  ReciterPlayerSlider({
    super.key,
    required this.currentValue,
    required this.maxValue,
    required this.onSeekChange,
  });

  @override
  _ReciterPlayerSliderState createState() => _ReciterPlayerSliderState();
}

class _ReciterPlayerSliderState extends State<ReciterPlayerSlider> {
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
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
        ),
        child: Slider(
          inactiveColor: lightGray,
          activeColor: primaryColor2,
          thumbColor: primaryColor,
          value: widget.currentValue.toDouble(),
          onChangeEnd: (value) async {
            widget.onSeekChange!(value);
            setState(() {
              widget.currentValue = value.toInt();
            });
          },
          onChanged: (value) async {
            // widget.onSeekChange!(value);
            setState(() {
              widget.currentValue = value.toInt();
            });
          },
          label: 'الآيه ${widget.currentValue.toInt()}',
          divisions: widget.maxValue,
          min: 1,
          max: widget.maxValue.toDouble() + 1,
        ),
      ),
    );
  }
}
