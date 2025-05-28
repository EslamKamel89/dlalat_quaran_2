import 'dart:ui';

import 'package:dlalat_quaran_new/controllers/player_bottom_controller.dart';
import 'package:dlalat_quaran_new/controllers/settings_controller.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/ui/player_bottom_widget.dart';
import 'package:dlalat_quaran_new/ui/short_explanation_index.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../utils/audio_download.dart';

// ignore: must_be_immutable
class SelectRecitationsDialog extends StatelessWidget {
  SettingsController settingsController = Get.put(SettingsController());

  PlayerBottomController playerBottomController;

  SelectRecitationsDialog(this.playerBottomController, {super.key});

  @override
  Widget build(BuildContext context) {
    settingsController.getReciters();
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Material(
        elevation: 3,
        color: const Color(0x5dffffff),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Center(
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 15),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                margin: const EdgeInsets.only(
                    top: 60, bottom: 30, left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.arrow_back_outlined),
                          onTap: () => Get.back(),
                        ),
                        Expanded(
                            child: Text(
                          'reciterName'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Almarai',
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                        const Icon(null),
                      ],
                    ),
                    Container(
                      color: Colors.grey,
                      height: .5,
                      margin: const EdgeInsets.only(
                        top: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: Get.height / 2.8,
                      child: Obx(() => settingsController.recitersList.isEmpty
                          ? const SizedBox()
                          : ListView.separated(
                              itemCount: settingsController.recitersList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 15, top: 5, bottom: 5),
                                    child: Text(
                                      settingsController.recitersList[index]
                                          .toString(),
                                      style: const TextStyle(
                                          fontFamily: "Almarai", fontSize: 15),
                                    ),
                                  ),
                                  onTap: () async {
                                    var preferences =
                                        await SharedPreferences.getInstance();
                                    await preferences.setString(
                                        reciterKey,
                                        settingsController
                                            .recitersList[index].id
                                            .toString());

                                    playerBottomController
                                            .currentReciter.value =
                                        await DataBaseHelper.dataBaseInstance()
                                            .getCurrentReciter(
                                                settingsController
                                                    .recitersList[index].id);

                                    currentReciter.value = settingsController
                                        .recitersList[index].id
                                        .toString();
                                    AudioDownload()
                                        .downloadPage(currentPage.value);
                                    await audioPlayer.stop();
                                    playerBottomController.update();
                                    Get.back();
                                  },
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider();
                              },
                            )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
