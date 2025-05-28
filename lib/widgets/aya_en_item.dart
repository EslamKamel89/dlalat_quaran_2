import 'package:dlalat_quaran_new/controllers/sura_en_controller.dart';
import 'package:dlalat_quaran_new/models/word_model.dart';
import 'package:dlalat_quaran_new/ui/dialog_word_tag.dart';
import 'package:dlalat_quaran_new/ui/player_bottom_widget.dart';
import 'package:dlalat_quaran_new/ui/short_explanation_index.dart';
import 'package:dlalat_quaran_new/utils/audio_download.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'explain_dialog.dart';

// ignore: must_be_immutable
class AyaEnItem extends StatelessWidget {
  List<WordModel> ayaModel;
  SuraEnController suraEnController;

  AyaEnItem({
    super.key,
    required this.ayaModel,
    required this.suraEnController,
  });

  ButtonStyle _customStyle(Color color) {
    return ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))));
  }

  List<TextSpan> _fullAyaAr() {
    List<TextSpan> spanList = [];

    for (var x = 0; x < ayaModel.length; x++) {
      var text = ayaModel[x].word_ar.toString() == 'null' ? '(${ayaModel[x].ayaNo})' : '${ayaModel[x].word_ar} ';
      spanList.add(TextSpan(
        text: x != ayaModel.length - 1 ? text : text,
        style: ayaModel[x].ayaId! != selectedAyaId.value
            ? ayaModel[x].tagId == 'null'
                ? suraEnController.normal
                : suraEnController.redStyle
            : suraEnController.playingStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (ayaModel[x].tagId == 'null') {
              Get.dialog(ExplainDialog(
                ayaKey: ayaModel[x].ayaId.toString(),
                videoId: ayaModel[x].videoId.toString(),
                ayaNumber: ayaModel[x].ayaNo,
                suraName: ayaModel[x].suraName,
              ));
            } else {
              Get.dialog(DialogWordTag(tagId: ayaModel[x].tagId!, wordId: ayaModel[x].word_id!));
            }
          },
      ));
    }
    return spanList;
  }

  List<TextSpan> _fullAyaEn() {
    List<TextSpan> spanList = [];

    for (var x = 0; x < ayaModel.length; x++) {
      var text = ayaModel[x].word_en.toString() == 'null' && ayaModel[x].char_type == 'end'
          ? '(${ayaModel[x].ayaNo})'
          : ayaModel[x].word_en!.toLowerCase() != 'null'
              ? '${ayaModel[x].word_en}'
              : "";
      spanList.add(TextSpan(
        text: x != ayaModel.length - 1 ? text : text,
        style: ayaModel[x].ayaId! != selectedAyaId.value
            ? ayaModel[x].tagId == 'null'
                ? suraEnController.normalEn
                : suraEnController.redStyleEn
            : suraEnController.playingStyleEn,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (ayaModel[x].tagId == 'null') {
              Get.dialog(ExplainDialog(
                ayaKey: ayaModel[x].ayaId.toString(),
                videoId: ayaModel[x].videoId.toString(),
                ayaNumber: ayaModel[x].ayaNo,
                suraName: ayaModel[x].suraName,
              ));
            } else {
              Get.dialog(DialogWordTag(tagId: ayaModel[x].tagId!, wordId: ayaModel[x].word_id!));
            }
          },
      ));
    }
    return spanList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: suraEnController.bgColor!, borderRadius: const BorderRadius.all(Radius.circular(8))),
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => Center(
                child: GestureDetector(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: _fullAyaAr(), style: DefaultTextStyle.of(context).style),
                  ),
                  onLongPress: () {
                    selectedAyaId.value = ayaModel[0].ayaId!;
                    selectAyaNo.value = ayaModel[0].ayaNo!.toString();
                    playerSuraId.value = int.parse(ayaModel[0].sura!);

                    AudioDownload()
                        .suraDownload(int.parse(ayaModel[0].sura!), ayaModel[0].ayaNo!, playerSuraCount.value);
                    suraEnController.update();
                  },
                ),
              )),
          Obx(() => Center(
                child: GestureDetector(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: _fullAyaEn(), style: DefaultTextStyle.of(context).style),
                  ),
                  onLongPress: () {
                    selectedAyaId.value = ayaModel[0].ayaId!;
                    selectAyaNo.value = ayaModel[0].ayaNo!.toString();
                    playerSuraId.value = int.parse(ayaModel[0].sura!);
                    suraEnController.update();

                    AudioDownload().suraDownloadPlay(
                        int.parse(ayaModel[0].sura!), ayaModel[0].ayaNo!, playerSuraCount.value, audioPlayer);
                  },
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    style: _customStyle(lightGray),
                    onPressed: () {
                      selectedAyaId.value = ayaModel[0].ayaId!;
                      selectAyaNo.value = ayaModel[0].ayaNo!.toString();
                      playerSuraId.value = int.parse(ayaModel[0].sura!);
                      suraEnController.update();

                      AudioDownload().suraDownloadPlay(
                          int.parse(ayaModel[0].sura!), ayaModel[0].ayaNo!, playerSuraCount.value, audioPlayer);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.volume_up,
                          color: Colors.blueGrey,
                          size: 25,
                        ),
                        Text(
                          'Sound',
                          style: TextStyle(color: Colors.blueGrey, fontSize: 10),
                        )
                      ],
                    )),
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: ElevatedButton(
                    style: _customStyle(lightGray),
                    onPressed: () => {
                          Get.dialog(ExplainDialog(
                            ayaKey: ayaModel[0].ayaId.toString(),
                            videoId: ayaModel[0].videoId.toString(),
                            ayaNumber: ayaModel[0].ayaNo,
                            suraName: ayaModel[0].suraName,
                          ))
                        },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/book.png',
                          height: 25,
                          width: 25,
                          color: const Color(0xff2680EB),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text('Explanation', style: TextStyle(color: Color(0xff2680EB), fontSize: 10))
                      ],
                    )),
              ),

              // const SizedBox(
              //   width: 7,
              // ),
              // Expanded(
              //   child: Visibility(
              //     visible: ayaModel[0].videoId != 'null',
              //     child: ElevatedButton(
              //         style: _customStyle(suraEnController.bgColor!),
              //         onPressed: () => print(''),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: const [
              //             Icon(
              //               Icons.videocam_outlined,
              //               color: Colors.deepOrange,
              //               size: 25,
              //             ),
              //             Text('Video',
              //                 style: TextStyle(
              //                     color: Colors.deepOrange, fontSize: 10))
              //           ],
              //         )),
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }
}
