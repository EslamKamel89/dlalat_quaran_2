import 'dart:ui';

import 'package:dlalat_quaran_new/controllers/dialog_word_tag_controller.dart';
import 'package:dlalat_quaran_new/controllers/download_link_controller.dart';
import 'package:dlalat_quaran_new/controllers/get_tag_controller.dart';
import 'package:dlalat_quaran_new/controllers/settings_controller.dart';
import 'package:dlalat_quaran_new/dialogs/custom_snack_bar.dart';
import 'package:dlalat_quaran_new/models/tag_model.dart';
import 'package:dlalat_quaran_new/ui/add_comment.dart';
import 'package:dlalat_quaran_new/ui/chat/helpers/clean_reply.dart';
import 'package:dlalat_quaran_new/ui/setting_screen.dart';
import 'package:dlalat_quaran_new/utils/calc_font_size.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:dlalat_quaran_new/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogWordTag extends StatefulWidget {
  final String tagId;
  final String wordId;

  const DialogWordTag({super.key, required this.tagId, required this.wordId});

  @override
  State<DialogWordTag> createState() => _DialogWordTagState();
}

class _DialogWordTagState extends State<DialogWordTag> {
  final DialogWordTagController _dialogController = Get.put(DialogWordTagController());

  final GetDownloadLinkController _downloadLinkController = Get.find<GetDownloadLinkController>();
  String? downloadLink;
  TagModel? tagModel;
  final GetTagController _getTagController = Get.find<GetTagController>();
  final t = 'DialogWordTag';

  @override
  void initState() {
    _getTagAndDownloadLink();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dialogController.getTagVideo(widget.tagId, int.parse(widget.wordId));
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Material(
        elevation: 1,
        color: const Color(0x5dffffff),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Container(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
          margin: const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
          child: GetBuilder<GetTagController>(
            builder: (_) {
              return Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.arrow_back_outlined),
                        onTap: () {
                          Get.back();
                          Get.delete<DialogWordTagController>();
                        },
                      ),
                      Expanded(
                        child: Html(data: tagModel?.name() ?? '', style: mainHtmlStyle()),
                        // Obx(() => Html(
                        //       data: _dialogController.wordName.value,
                        //       style: mainHtmlStyle(),
                        //     )),
                      ),
                      const Icon(null),
                    ],
                  ),
                  Container(color: Colors.grey, height: .5, margin: const EdgeInsets.only(top: 15, bottom: 15)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        String shareContent = 'شرح الكلمة الدلالية: ';
                        shareContent = '$shareContent ${tagModel?.name() ?? ''}';
                        shareContent = '$shareContent\n${tagModel?.descriptionWithNoTags() ?? ''}';
                        Share.share(shareContent, subject: tagModel?.name() ?? '');
                      },
                      icon: const Icon(Icons.share, color: primaryColor),
                    ),
                  ),
                  tagModel?.description() != 'null' && tagModel?.description() != ''
                      ? Expanded(
                        flex: 1,
                        child: Scrollbar(
                          trackVisibility: true,
                          scrollbarOrientation: ScrollbarOrientation.right,
                          radius: const Radius.circular(10),
                          thumbVisibility: true,
                          thickness: 10,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12, left: 12),
                              child:
                              // Obx(() =>
                              Container(
                                margin: const EdgeInsetsDirectional.only(start: 20, end: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Html(
                                      // data: _dialogController.description.value,
                                      data: cleanHtml(tagModel?.description() ?? ''),
                                      style: mainHtmlStyle(),
                                    ),
                                    GetBuilder<GetDownloadLinkController>(
                                      builder: (_) {
                                        if (downloadLink != null) {
                                          return TextButton(
                                            onPressed: () {
                                              launchUrl(Uri.parse(downloadLink!));
                                            },
                                            child: Text(
                                              'أقرا المزيد',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: calcFontSize(
                                                  Get.find<SettingsController>().fontTypeEnum == FontType.normal
                                                      ? 14
                                                      : 18,
                                                ),
                                                fontFamily: 'Almarai',
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // ),
                            ),
                          ),
                        ),
                      )
                      : SizedBox(),
                  // : Expanded(
                  //   child: GridView.count(
                  //     crossAxisCount: 2,
                  //     children:
                  //         _dialogController.videoModels.map((e) {
                  //           // e.name = _dialogController.wordName.value;
                  //           return VideoItemDialog(videoModel: e);
                  //         }).toList(),
                  //   ),
                  // ),

                  // ),
                  // Obx(
                  //   () =>
                  //       _dialogController.videoModels.isNotEmpty &&
                  //               _dialogController.description.value != 'null' &&
                  //               _dialogController.description.value != ''
                  //           ? SizedBox(
                  //             height: 170,
                  //             child: ListView.builder(
                  //               itemBuilder: (context, index) {
                  //                 _dialogController.videoModels[index].name = _dialogController.wordName.value;
                  //                 return VideoItemDialog(videoModel: _dialogController.videoModels[index]);
                  //               },
                  //               itemCount: _dialogController.videoModels.length,
                  //               scrollDirection: Axis.horizontal,
                  //             ),
                  //           )
                  //           : const SizedBox(),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      PrimaryButton(
                        onPressed: () {
                          Get.toNamed(AddCommentView.id, arguments: {"id": widget.tagId, 'commentType': 'tag'});
                        },
                        borderRadius: 5,
                        child: Text(
                          'addComment'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: calcFontSize(18),
                            fontFamily: 'Almarai',
                          ),
                        ),
                      ),
                      // const SizedBox(width: 5),
                      // GetBuilder<GetDownloadLinkController>(
                      //   builder: (_) {
                      //     if (downloadLink != null) {
                      //       return PrimaryButton(
                      //         onPressed: () {
                      //           launchUrl(Uri.parse(downloadLink!));
                      //         },
                      //         borderRadius: 5,
                      //         child: Text(
                      //           'تحميل'.tr,
                      //           style: const TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.white,
                      //             fontSize: 18,
                      //             fontFamily: 'Almarai',
                      //           ),
                      //         ),
                      //       );
                      //     } else {
                      //       return const SizedBox();
                      //     }
                      //   },
                      // ),
                      const Spacer(),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future _getTagAndDownloadLink() async {
    try {
      _getTagController.getTag(id: int.parse(widget.tagId)).then((value) {
        tagModel = value;
        pr(tagModel, '$t - tagModel');
        _downloadLinkController
            .getDownloadlink(downloadLinkType: DownloadLinkType.tag, id: tagModel?.id.toString() ?? '')
            .then((value) {
              pr(value, '$t - downloadLink');
              return downloadLink = value;
            });
      });
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      showCustomSnackBarFailure();
    }
  }
}
