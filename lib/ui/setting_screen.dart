import 'dart:developer';

import 'package:dlalat_quaran_new/controllers/read_aya_controller.dart';
import 'package:dlalat_quaran_new/controllers/settings_controller.dart';
import 'package:dlalat_quaran_new/dialogs/custom_snack_bar.dart';
import 'package:dlalat_quaran_new/models/language_model.dart';
import 'package:dlalat_quaran_new/network/sync_manager.dart';
import 'package:dlalat_quaran_new/ui/about_app_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:dlalat_quaran_new/widgets/custom_buttons.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:dlalat_quaran_new/widgets/font_type_radio.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FontType { normal, bold }

//ignore: must_be_immutable
class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  static String id = '/SettingScreen';
  SettingsController controller = Get.find<SettingsController>();
  var screenWidth = Get.width;

  @override
  Widget build(BuildContext context) {
    controller.onInit();
    controller.getReciters();
    // initScreenUtil(context);
    return WillPopScope(
      onWillPop: () async {
        Get.delete<SettingsController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGray2,
        appBar: QuranBar('settings'.tr),
        body: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       flex: 1,
                    //       child: Text(
                    //         'language'.tr,
                    //         style: const TextStyle(fontFamily: 'Almarai'),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       flex: 4,
                    //       child: Container(
                    //         margin: const EdgeInsets.only(left: 8, right: 8),
                    //         height: 50,
                    //         decoration: const BoxDecoration(
                    //             borderRadius: BorderRadius.all(Radius.circular(8)), color: Colors.white),
                    //         child: LanguageSpinner(controller),
                    //       ),
                    //     )
                    //   ],
                    // ),

                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'reciter'.tr,
                            style: const TextStyle(fontFamily: 'Almarai'),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            height: 50,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)), color: Colors.white),
                            child: const RecitersSpinner(),

                            // child: LanguageSpinner(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'fontType'.tr,
                            style: const TextStyle(fontFamily: 'Almarai'),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)), color: Colors.white),
                            child: Obx(
                              () => controller.mFontType.value != null
                                  ? FontTypeRadio(controller)
                                  : FontTypeRadio(controller),
                            ),
                            // child: LanguageSpinner(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    // Obx(() => controller.colorLoading.value
                    //     ? const SizedBox(
                    //         height: 180,
                    //       )
                    //     : Column(
                    //         children: [
                    //           AlMaraiText(0, 'اعدادات صفحة المصحف'),
                    //           ColorPickerWidget(
                    //             tilte: 'خلفية الصفحة',
                    //             controller: controller,
                    //             type: KpageBg,
                    //           ),
                    //           ColorPickerWidget(
                    //             tilte: 'لون الخط',
                    //             controller: controller,
                    //             type: KnormalFontColor,
                    //           ),
                    //           ColorPickerWidget(
                    //             tilte: 'الكلمات الدلالية',
                    //             controller: controller,
                    //             type: KtagWordsColor,
                    //           ),
                    //           ColorPickerWidget(
                    //             tilte: 'التلاوة',
                    //             controller: controller,
                    //             type: KreadWordsColor,
                    //           ),
                    //         ],
                    //       )),

                    Container(
                      height: 60,
                      width: Get.width / 1.5,
                      margin: const EdgeInsets.only(top: 15, left: 50, right: 50),
                      child: PrimaryButton(
                          onPressed: () {
                            final SyncManager syncManager = Get.find();
                            syncManager.syncData(forceUpdate: true);
                            showCustomSnackBar(title: "برجاء الأنتظار", body: "يتم تحميل البيانات من قاعدة البيانات");

                            pr('data updated ');
                          },
                          borderRadius: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.cached,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'update'.tr,
                                textScaleFactor: 1.0,
                                style: const TextStyle(
                                    color: Colors.white, fontFamily: 'Almarai', height: 1.5, fontSize: 15),
                              )
                            ],
                          )),
                    ),
                    Container(
                      height: 60,
                      width: Get.width / 1.5,
                      margin: const EdgeInsets.only(top: 15, left: 50, right: 50),
                      child: PrimaryButton(
                          onPressed: () {
                            showCustomSnackBar(title: 'نجاح', body: "تم حفظ الأعدادات");
                            // controller.saveSetting();
                            // Get.back();
                            // Get.delete<SettingsController>();
                          },
                          borderRadius: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'save'.tr,
                                textScaleFactor: 1.0,
                                style: const TextStyle(
                                    color: Colors.white, fontFamily: 'Almarai', height: 1.5, fontSize: 15),
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: const BoxDecoration(),
                      margin: const EdgeInsets.only(
                        bottom: 30,
                      ),
                      height: 60,
                      width: Get.width / 1.5,
                      child: PrimaryButton(
                        onPressed: () => Get.to(const AboutAppScreen(), transition: Transition.fadeIn),
                        borderRadius: 15,
                        child: Stack(
                          children: [
                            Image.asset(
                              toolBarBackImage,
                              fit: BoxFit.cover,
                              height: Get.height / 11,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: Image.asset(
                                      logoSmall,
                                      height: 20,
                                    )),
                                    Center(
                                        child: Text(
                                      'app_name'.tr,
                                      textScaleFactor: 1.0,
                                      style: const TextStyle(
                                          color: Colors.white, fontFamily: 'Almarai', height: 1.5, fontSize: 10),
                                    ))
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Center(
                                    child: Text(
                                  'about_app'.tr,
                                  textScaleFactor: 1.0,
                                  style: const TextStyle(
                                      color: Colors.white, fontFamily: 'Almarai', height: 1.5, fontSize: 15),
                                ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => AlMaraiText(12, 'آخر تحديث ${controller.lastSyncDate.value}'),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}

//ignore: must_be_immutable
class LanguageSpinner extends StatefulWidget {
  late SettingsController controller;

  LanguageSpinner(this.controller, {super.key});

  @override
  _LanguageSpinnerState createState() => _LanguageSpinnerState();
}

class _LanguageSpinnerState extends State<LanguageSpinner> {
  @override
  Widget build(BuildContext context) {
    print(
        "Current Value ${modes[widget.controller.langPosition.value]} & Position => ${widget.controller.langPosition.value}");
    return DropdownButton<LanguageModel?>(
      value: modes[widget.controller.lanIndex()],
      items: modes.map<DropdownMenuItem<LanguageModel?>>((LanguageModel? value) {
        return DropdownMenuItem<LanguageModel?>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              children: [
                Image.asset(
                  value!.langFlag,
                  height: 30,
                  width: 40,
                ),
                AlMaraiText(0, value.langName)
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          // val = value!;
          log('Lang Postion =>>> ${value!.langName}');
          widget.controller.setSelectedLocale(value.lagId);
          serviceLocator<SharedPreferences>().clear();
        });
      },
      isExpanded: true,
      underline: const SizedBox(),
    );
  }
}

class RecitersSpinner extends StatefulWidget {
  // late SettingsController controller;

  const RecitersSpinner({super.key});

  @override
  _RecitersSpinnerState createState() => _RecitersSpinnerState();
}

class _RecitersSpinnerState extends State<RecitersSpinner> {
  ReadAyaController readAyaController = Get.find<ReadAyaController>();
  @override
  Widget build(BuildContext context) {
    return DropdownButton<ReaderName>(
      value: readAyaController.readerName,
      items: readAyaController.readersList.map<DropdownMenuItem<ReaderName>>((ReaderName readerName) {
        return DropdownMenuItem<ReaderName>(
          value: readerName,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: AlMaraiText(0, readerName.displayName()),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          readAyaController.readerName = value;
          setState(() {});
        }
      },
      isExpanded: true,
      underline: const SizedBox(),
    );
  }
}
