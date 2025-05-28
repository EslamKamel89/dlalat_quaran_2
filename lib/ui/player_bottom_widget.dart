import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dlalat_quaran_new/controllers/player_bottom_controller.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/ui/new_single_sura_screen.dart';
import 'package:dlalat_quaran_new/ui/short_explanation_index.dart';
import 'package:dlalat_quaran_new/ui/sura_en_screen.dart';
import 'package:dlalat_quaran_new/ui/sura_screen.dart';
import 'package:dlalat_quaran_new/utils/audio_download.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:dlalat_quaran_new/widgets/loading_widget.dart';
import 'package:dlalat_quaran_new/widgets/player_slider.dart';
import 'package:dlalat_quaran_new/widgets/select_recitations_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/audio_folders.dart';

AudioPlayer audioPlayer = AudioPlayer();
PlayerState? _playerState = PlayerState.stopped;
var listenerStart = false;
var controllerObject = PlayerBottomController();

class PlayerBottomWidget extends StatelessWidget {
  final String _locale = GetStorage().read(language);
  int ayaId = 0;
  int ayaNo = 1;
  bool isPaused = false;
  PlayerBottomController playerBottomController = Get.put(controllerObject);
  String reciterId = '1';
  PlayerBottomWidget({super.key, required this.ayaId, required this.ayaNo});

  late PlayerSlider playerSlider;

  void initPlayer() async {
    audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    controllerObject.getCurrentReciter();
    if (ayaNo != 0) {
      playerSlider = PlayerSlider(
        currentValue: ayaNo,
        maxValue: playerSuraCount.value,
        onSeekChange: null,
      );
    } else {
      playerSlider = PlayerSlider(currentValue: 1, maxValue: 2, onSeekChange: null);
    }
  }

  void listener() async {
    if (!listenerStart) {
      audioPlayer.onPlayerStateChanged.listen((event) async {
        _playerState = event;
        playerBottomController.isPlaying.value = event == PlayerState.playing;
        if (event == PlayerState.playing) {
          // var newAya = int.parse(selectAyaNo.value) + 1;
          // if (newAya <= playerSuraCount.value) {
          //   playerBottomController.getNextRecitationModel(
          //       playerSuraId.value, (newAya).toString());
          // } else {
          //   // playerSuraId.value = playerSuraId.value + 1;
          //   playerSuraCount.value = await DataBaseHelper.dataBaseInstance()
          //       .suraCount(playerSuraId.value);
          //   print('end next sura = ${playerSuraId.value}');
          //   selectAyaNo.value = '0';
          //   playerBottomController.getNextRecitationModel(
          //       (playerSuraId.value + 1), (1).toString());
          // }
        }
        initPlayer();
        playerBottomController.update();
      });

      audioPlayer.onPlayerComplete.listen((event) async {
        _playNext();
      });
    }
    listenerStart = true;
  }

  void listenerEn() async {
    if (!listenerStart) {
      audioPlayer.onPlayerStateChanged.listen((event) async {
        _playerState = event;
        playerBottomController.isPlaying.value = event == PlayerState.playing;
      });

      audioPlayer.onPlayerComplete.listen((event) async {
        selectedAyaId.value = (int.parse(selectedAyaId.value) + 1).toString();
        selectAyaNo.value = (int.parse(selectAyaNo.value) + 1).toString();
        initPlayer();

        reciterId = playerBottomController.currentReciter.value.id.toString();

        String fullPath = await AudioFolders().generatePath(
          reciterId,
          playerSuraId.value.toString(),
          selectAyaNo.value,
        );
        await audioPlayer.play(DeviceFileSource(fullPath));

        if (autoScrollController != null) {
          autoScrollController!.scrollToIndex(int.parse(selectAyaNo.value) - 1);
        } else {
          log('scroller====null ,, ${selectAyaNo.value} ');
        }
      });
    }
    listenerStart = true;
  }

  @override
  Widget build(BuildContext context) {
    initPlayer();
    if (GetStorage().read(language) == 'ar') {
      listener();
    } else {
      listenerEn();
    }

    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        // Main Column
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(width: 5),
                    Obx(
                      () => playerBottomController.currentReciter.value.id != null
                          ? Center(
                              child: AlMaraiTextBottom(
                                isSmallScreen ? 10 : 13,
                                playerBottomController.currentReciter.value.id != 0
                                    ? playerBottomController.currentReciter.value.toString()
                                    : '1',
                              ),
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: isSmallScreen ? 15 : 25,
                      child: ElevatedButton(
                        onPressed: () =>
                            Get.dialog(SelectRecitationsDialog(playerBottomController)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF1F2F5),
                          padding: const EdgeInsets.all(0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            'changeReciter'.tr,
                            textScaleFactor: 1.0,
                            style: const TextStyle(
                              fontSize: 10,
                              fontFamily: 'Almarai',
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => playerBottomController.isLoading.value
                          ? const LoadingWidget()
                          : const SizedBox(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          playerSlider,
          // const SizedBox(
          //   height: 5,
          // ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    if (!playerBottomController.isLoading.value) {
                      _playPrev();
                    } else {
                      _loadingSnack();
                    }
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
                    if (!playerBottomController.isLoading.value) {
                      var isNetAvailable = await AudioDownload().isInternetAvailable();

                      switch (_playerState!) {
                        case PlayerState.stopped:
                          // if (isNetAvailable) {
                          //   audioPlayer.play(playerBottomController.ayaUrl(
                          //       playerSuraId.value, ayaNo.toString()));
                          playerBottomController.isPlaying.value = true;
                          //   playerBottomController.update();
                          // } else {
                          //   playerBottomController.internetSnack();
                          // }

                          String fullPath = await AudioFolders().generatePath(
                            playerBottomController.currentReciter.value.id.toString(),
                            playerSuraId.value.toString(),
                            selectAyaNo.value,
                          );

                          await audioPlayer.play(DeviceFileSource(fullPath));

                          break;
                        case PlayerState.playing:
                          audioPlayer.pause();
                          playerBottomController.isPlaying.value = false;
                          playerBottomController.update();

                          break;
                        case PlayerState.paused:
                          audioPlayer.resume();
                          playerBottomController.isPlaying.value = false;
                          playerBottomController.update();
                          break;
                        case PlayerState.completed:
                          playerBottomController.isPlaying.value = false;
                          playerBottomController.update();
                          break;
                        case PlayerState.disposed:
                          // TODO: Handle this case.
                          throw UnimplementedError();
                      }
                    } else {
                      _loadingSnack();
                    }
                  },
                  customBorder: const CircleBorder(),
                  child: Obx(
                    () => Image.asset(
                      playerBottomController.isPlaying.value
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
                    if (!playerBottomController.isLoading.value) {
                      await audioPlayer.stop();
                      _playNext();
                    } else {
                      _loadingSnack();
                    }
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
          ),
        ],
      ),
    );
  }

  void _playNext() async {
    if (int.parse(selectAyaNo.value) < playerSuraCount.value) {
      selectedAyaId.value = (int.parse(selectedAyaId.value) + 1).toString();
      selectAyaNo.value = (int.parse(selectAyaNo.value) + 1).toString();
      initPlayer();
      currentPage.value = await DataBaseHelper.dataBaseInstance().getAyaPage(selectedAyaId.value);

      if (currentPage.value != currentPageNotifier.value) {
        pageController.jumpToPage(currentPage.value - 1);
      }

      // currentPageNotifier.value = currentPage.value;
      if (parentWidget != null) {
        if (parentWidget!.mounted) {
          parentWidget!.setState(() {});
          // await audioPlayer.play(playerBottomController.ayaUrl(
          //     playerSuraId.value, (int.parse(selectAyaNo.value)).toString()));
        }
      }

      selectedAyaId.value = (int.parse(selectedAyaId.value)).toString();
      selectAyaNo.value = (int.parse(selectAyaNo.value)).toString();

      initPlayer();
      reciterId = playerBottomController.currentReciter.value.id.toString();

      String fullPath = await AudioFolders().generatePath(
        reciterId,
        playerSuraId.value.toString(),
        selectAyaNo.value,
      );
      await audioPlayer.play(DeviceFileSource(fullPath));
    }
  }

  void _playPrev() async {
    await audioPlayer.stop();
    if (int.parse(selectAyaNo.value) > 1) {
      selectedAyaId.value = (int.parse(selectedAyaId.value) - 1).toString();
      selectAyaNo.value = (int.parse(selectAyaNo.value) - 1).toString();
      initPlayer();
      currentPage.value = await DataBaseHelper.dataBaseInstance().getAyaPage(selectedAyaId.value);

      if (currentPage.value != currentPageNotifier.value) {
        pageController.jumpToPage(currentPage.value - 1);
      }

      // currentPageNotifier.value = currentPage.value;
      if (parentWidget != null) {
        if (parentWidget!.mounted) {
          parentWidget!.setState(() {});
          // await audioPlayer.play(playerBottomController.ayaUrl(
          //     playerSuraId.value, (int.parse(selectAyaNo.value)).toString()));
        }
      }

      selectedAyaId.value = (int.parse(selectedAyaId.value)).toString();
      selectAyaNo.value = (int.parse(selectAyaNo.value)).toString();

      initPlayer();
      reciterId = playerBottomController.currentReciter.value.id.toString();

      String fullPath = await AudioFolders().generatePath(
        reciterId,
        playerSuraId.value.toString(),
        selectAyaNo.value,
      );
      await audioPlayer.play(DeviceFileSource(fullPath));
    }
  }

  void _loadingSnack() {
    Get.snackbar(
      'recitations'.tr,
      'audioLoadingMsg'.tr,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
      backgroundColor: primaryColor,
      colorText: Colors.white,
    );
  }
}
