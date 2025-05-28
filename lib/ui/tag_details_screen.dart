import 'package:dlalat_quaran_new/controllers/download_link_controller.dart';
import 'package:dlalat_quaran_new/controllers/get_tag_controller.dart';
import 'package:dlalat_quaran_new/controllers/settings_controller.dart';
import 'package:dlalat_quaran_new/controllers/tag_details_controller.dart';
import 'package:dlalat_quaran_new/models/tag_model.dart';
import 'package:dlalat_quaran_new/ui/add_comment.dart';
import 'package:dlalat_quaran_new/ui/setting_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:dlalat_quaran_new/widgets/custom_buttons.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// late TagModel model;

//ignore: must_be_immutable
class TagDetailsScreen extends StatefulWidget {
  static String id = '/TagDetailsScreen';

  const TagDetailsScreen({super.key});

  @override
  State<TagDetailsScreen> createState() => _TagDetailsScreenState();
}

class _TagDetailsScreenState extends State<TagDetailsScreen> {
  final TagDetailsController _detailsController = Get.put(TagDetailsController());
  final GetDownloadLinkController _downloadLinkController = Get.find<GetDownloadLinkController>();
  final GetTagController _getTagController = Get.find<GetTagController>();
  String? downloadLink;
  TagModel? tagModel;
  int? id;
  final t = 'TagDetailsScreen';
  @override
  void initState() {
    // model = TagModel.fromJson(Get.arguments);
    // _detailsController.updateTagModel(model);
    // _detailsController.getTagVideos();

    id = Get.arguments;
    if (id == null) {
      pr('id recieved in tag details screen is null', t);
      return;
    }
    pr(id, '$t tagId');
    _getTagController.getTag(id: id!).then((value) {
      tagModel = value;
      pr(tagModel, '$t - tagModel');
      _downloadLinkController
          .getDownloadlink(downloadLinkType: DownloadLinkType.tag, id: tagModel?.id.toString() ?? '')
          .then(
        (value) {
          pr(value, '$t - downloadLink');
          return downloadLink = value;
        },
      );
    }).then((_) {
      _detailsController.tagId = (tagModel?.id)!;
      // _detailsController.tagId = 476;
      _detailsController.getRelatedTags();
    });
    super.initState();
  }

  @override
  void dispose() {
    TagDetailsData.tagVideos = [];
    TagDetailsData.relatedTags = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initScreenUtil(context);
    return GetBuilder<GetTagController>(builder: (_) {
      return Scaffold(
        // appBar: QuranBar(_detailsController.selectedTagModel.value.name()),
        appBar: QuranBar(tagModel?.name() ?? ''),
        backgroundColor: lightGray2,
        body: tagModel != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // _detailsController.selectedTagModel.value.name(),
                          tagModel?.name() ?? '',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: primaryColor, fontSize: 18, fontFamily: 'Almarai'),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                              onPressed: () {
                                String shareContent = 'شرح الكلمة الدلالية: ';
                                shareContent = '$shareContent ${tagModel?.name() ?? ''}';
                                shareContent = '$shareContent\n${tagModel?.descriptionWithNoTags() ?? ''}';
                                Share.share(
                                  shareContent,
                                  subject: tagModel?.name() ?? '',
                                );
                              },
                              icon: const Icon(Icons.share, color: primaryColor)),
                        ),
                        // GestureDetector(
                        //   child: const Icon(
                        //     Icons.videocam_rounded,
                        //     size: 40,
                        //     color: primaryColor2,
                        //   ),
                        //   onTap: () {
                        //     Get.dialog(DialogTagVideos(_detailsController.selectedTagModel.value));
                        //   },
                        // ),
                        //        Obx(() => Text(
                        //       _detailsController.selectedTagModel.value.name(),
                        //       textAlign: TextAlign.start,
                        //       style: const TextStyle(
                        //           fontWeight: FontWeight.bold, color: primaryColor, fontSize: 18, fontFamily: 'Almarai'),
                        //     )),
                        // Obx(() => TagDetailsData.tagVideos.isNotEmpty
                        //     ? GestureDetector(
                        //         child: const Icon(
                        //           Icons.videocam_rounded,
                        //           size: 40,
                        //           color: primaryColor2,
                        //         ),
                        //         onTap: () {
                        //           Get.dialog(DialogTagVideos(_detailsController.selectedTagModel.value));
                        //         },
                        //       )
                        //     : const SizedBox())
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: lightGray2, width: 1)),
                      margin: const EdgeInsets.only(top: 20, bottom: 20, right: 10, left: 10),
                      child: Scrollbar(
                        trackVisibility: true,
                        // hoverThickness: 50,
                        scrollbarOrientation: ScrollbarOrientation.right,
                        radius: const Radius.circular(10),
                        thumbVisibility: true,
                        thickness: 10,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsetsDirectional.only(start: 20, end: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Html(
                                  // data: _detailsController.selectedTagModel.value.description(),
                                  data: tagModel?.description(),
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
                                              fontSize: Get.find<SettingsController>().fontTypeEnum == FontType.normal
                                                  ? 14
                                                  : 18,
                                              fontFamily: 'Almarai',
                                            ),
                                          ));
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //       width: double.infinity,
                          //       child: Text(
                          //         _detailsController.selectedTagModel.value
                          //             .description(),
                          //         textAlign: TextAlign.justify,
                          //       ),
                          //     )
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      PrimaryButton(
                        onPressed: () {
                          Get.toNamed(AddCommentView.id, arguments: {"id": tagModel?.id, 'commentType': 'tag'});
                        },
                        borderRadius: 5,
                        child: Text(
                          'addComment'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Almarai',
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 15),
                  GetBuilder<TagDetailsController>(builder: (_) {
                    return Visibility(
                      // To Be Continue
                      visible: TagDetailsData.relatedTags.isNotEmpty,
                      // visible: true,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'read_also'.tr,
                                style: const TextStyle(color: primaryColor, fontFamily: "Almarai"),
                              ),
                            ),
                            Container(
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.only(left: 3, right: 3),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: TagDetailsData.relatedTags.length,
                                itemBuilder: (context, index) {
                                  return ElevatedButton(
                                    // onPressed: () {
                                    //   _detailsController.updateTagModel(TagDetailsData.relatedTags[index]);
                                    // },
                                    onPressed: () {
                                      Get.to(const TagDetailsScreen(),
                                          transition: Transition.fade,
                                          arguments: TagDetailsData.relatedTags[index].id,
                                          preventDuplicates: false);
                                    },

                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.blueGrey,
                                        backgroundColor: Colors.white,
                                        padding: EdgeInsets.zero,
                                        elevation: 2),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: Text(
                                        TagDetailsData.relatedTags[index].name(),
                                        style: const TextStyle(fontFamily: 'Almarai'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              )
            : _getTagController.responseState == ResponseState.loading
                ? const Center(child: CircularProgressIndicator())
                : const Center(child: DefaultText('نأسف لحدوث خطا, نرجو المحاولة في وقت لاحق ')),
      );
    });
  }
}

// this widget not used any where
class EvidenceDetailsBody extends StatelessWidget {
  const EvidenceDetailsBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              Container(
                margin: const EdgeInsetsDirectional.only(start: 20, end: 10),
                child: Html(
                  // data: model.desc_ar,
                  data: '',
                  style: mainHtmlStyle(),
                ),
              ),
            ],
          )),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 100,
            height: 45,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.zero,
                    elevation: 2),
                onPressed: () => print(''), // Video Click
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_fill,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'فيديو',
                      style: TextStyle(fontFamily: 'Almarai'),
                    )
                  ],
                )),
          ) // Video Button
        ],
      ),
    );
  }
}
