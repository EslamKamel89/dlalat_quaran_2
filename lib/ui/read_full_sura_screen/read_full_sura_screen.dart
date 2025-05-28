import 'package:audioplayers/audioplayers.dart';
import 'package:dlalat_quaran_new/controllers/read_full_surah_controller.dart';
import 'package:dlalat_quaran_new/ui/intro_screen.dart';
import 'package:dlalat_quaran_new/ui/read_full_sura_screen/widgets/new_ayas_spinner.dart';
import 'package:dlalat_quaran_new/ui/read_full_sura_screen/widgets/new_suras_spinner.dart';
import 'package:dlalat_quaran_new/ui/read_full_sura_screen/widgets/read_full_sura_audio_player.dart';
import 'package:dlalat_quaran_new/ui/setting_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadFullSuraScreen extends StatefulWidget {
  const ReadFullSuraScreen({super.key});
  static String id = '/ReadFullSuraScreen';

  @override
  State<ReadFullSuraScreen> createState() => _ReadFullSuraScreenState();
}

class _ReadFullSuraScreenState extends State<ReadFullSuraScreen> {
  late ReadFullSurahController controller;
  late AudioPlayer audioPlayer;
  @override
  void initState() {
    controller = Get.put(ReadFullSurahController());
    pr('init state is called');
    audioPlayer = controller.audioPlayer;
    super.initState();
  }

  @override
  void dispose() {
    controller.clearAllData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 10);
    return Builder(
      builder: (_) {
        return Scaffold(
          backgroundColor: lightGray,
          appBar: QuranBar(
            'audio_recitations'.tr,
            backCallback: () {
              controller.clearAllData();
              Get.offNamedUntil(IntroScreen.id, (_) => false);
              // Navigator.of(context).pop();
              // Navigator.of(context)
              // .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const IntroScreen()), (_) => false);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.only(),
            child: Column(
              children: [
                Center(
                    child: Image.asset(
                  soundMedium,
                  height: 100,
                )),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: horizontalPadding,
                  child: Row(
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
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: horizontalPadding,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'choose_sura'.tr,
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
                          child: const NewSurasSpinner(),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: horizontalPadding,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'choose_aya'.tr,
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
                          child: const NewAyasSpinner(),
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                GetBuilder<ReadFullSurahController>(builder: (_) {
                  return controller.selectedSuraModel == null ? const SizedBox() : const AudioPlayerFullSuraWidget();
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
