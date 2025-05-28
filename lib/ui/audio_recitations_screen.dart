import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dlalat_quaran_new/controllers/audio_recitation_controller.dart';
import 'package:dlalat_quaran_new/utils/audio_download.dart';
import 'package:dlalat_quaran_new/utils/audio_folders.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/widgets/audio_recitation_player.dart';
import 'package:dlalat_quaran_new/widgets/ayat_spinner.dart';
import 'package:dlalat_quaran_new/widgets/custom_buttons.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:dlalat_quaran_new/widgets/reciters_spinner.dart';
import 'package:dlalat_quaran_new/widgets/sura_spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioRecitationsScreen extends StatelessWidget {
  static String id = '/AudioRecitationsScreen';
  AudioRecitationController controller = Get.put(AudioRecitationController());
  final AudioPlayer _recitationPlayer = AudioPlayer();
  var listenerStart = false;

  var reciterId = 0;
  var suraId = 0;
  var ayaNo = 0;
  var suraCount = 0;

  AudioRecitationsScreen({super.key});

  void listener() {
    var conf = AudioContext(
      android: const AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
      ),
      iOS: AudioContextIOS(
        // defaultToSpeaker: true,
        category: AVAudioSessionCategory.playback,
        // options: <AVAudioSessionOptions>[],
      ),
    );
    // GlobalPlatformInterface.instance.setGlobalAudioContext(conf);

    controller.audioPlayer ??= _recitationPlayer;
    if (!listenerStart) {
      _recitationPlayer.onPlayerStateChanged.listen((event) {
        controller.playerState = event;
        controller.isPlaying.value = event == PlayerState.playing;
        if (event == PlayerState.playing) {
          // controller.getNextRecitationModel(controller.selectedSura.value.id!,
          //     (int.parse(controller.selectAya.value) + 1).toString());
        }
        controller.update();
      });

      _recitationPlayer.onPlayerComplete.listen((event) async {
        log('Oplya Next ${controller.selectAya.value}');
        if (int.parse(controller.selectAya.value) <= controller.selectedSuraAyatCount.value) {
          var next = int.parse(controller.selectAya.value) + 1;
          controller.selectAya.value = next.toString();
          controller.update();
          var ayaPath = await AudioFolders().generatePath(
            controller.selectedReciter.value.id.toString(),
            controller.suraId.value.toString(),
            controller.selectAya.value,
          );
          // await _recitationPlayer.stop();

          _recitationPlayer.play(DeviceFileSource(ayaPath));
        } else {
          await _recitationPlayer.stop();
        }
      });
    }
    listenerStart = true;
  }

  @override
  Widget build(BuildContext context) {
    controller.getReciter();
    listener();
    // initScreenUtil(context);
    return WillPopScope(
      onWillPop: () async {
        _recitationPlayer.release();
        Get.delete<AudioRecitationController>();
        Get.back();
        return false;
      },
      child: Scaffold(
        backgroundColor: lightGray,
        appBar: QuranBar('audio_recitations'.tr),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 35),
          child: Column(
            children: [
              Center(child: Image.asset(soundMedium, height: Get.width / 2.5)),
              const SizedBox(height: 35),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('reciter'.tr, style: const TextStyle(fontFamily: 'Almarai')),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.white,
                      ),
                      child: Obx(
                        () => controller.recitersList.value.isNotEmpty
                            ? RecitersSpinner(controller)
                            : const Text(''),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('choose_sura'.tr, style: const TextStyle(fontFamily: 'Almarai')),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.white,
                      ),
                      child: Obx(
                        () => controller.surasList.value.isNotEmpty
                            ? SuraSpinner(controller)
                            : const SizedBox(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('choose_aya'.tr, style: const TextStyle(fontFamily: 'Almarai')),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.white,
                      ),
                      child: Obx(
                        () => controller.ayatList.value.isNotEmpty
                            ? AyatSpinner(controller)
                            : const Text(''),
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                children: [
                  Container(
                    width: Get.width / 1.8,
                    height: 50,
                    margin: const EdgeInsets.only(top: 30),
                    child: PrimaryButton(
                      onPressed: () async {
                        controller.playerVisibleState(true);

                        await _recitationPlayer.stop();
                        AudioDownload().reciterId = controller.selectedReciter.value.id.toString();
                        AudioDownload().suraDownloadPlay(
                          controller.suraId.value,
                          int.parse(controller.selectAya.value),
                          controller.selectedSuraAyatCount.value,
                          _recitationPlayer,
                        );
                      },
                      borderRadius: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(soundIcon, width: 30, height: 30),
                          const SizedBox(width: 7),
                          AlMaraiText(0, 'start_recitation'.tr),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Obx(
                () => controller.showPlayer.value
                    ? AudioRecitationPlayer(controller)
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
