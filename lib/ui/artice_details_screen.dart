import 'package:dlalat_quaran_new/controllers/article_details_controller.dart';
import 'package:dlalat_quaran_new/controllers/download_link_controller.dart';
import 'package:dlalat_quaran_new/controllers/get_article_controller.dart';
import 'package:dlalat_quaran_new/controllers/settings_controller.dart';
import 'package:dlalat_quaran_new/models/article_model.dart';
import 'package:dlalat_quaran_new/ui/add_comment.dart';
import 'package:dlalat_quaran_new/ui/chat/helpers/clean_reply.dart';
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
import 'package:html/parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

//ignore: must_be_immutable
class ArticleDetailsScreen extends StatefulWidget {
  static String id = '/ArticleDetailsScreen';

  const ArticleDetailsScreen({super.key});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  // late ArticleModel model;

  final ArticlesDetailsController _detailsController = Get.put(ArticlesDetailsController());
  final GetDownloadLinkController _downloadLinkController = Get.find<GetDownloadLinkController>();
  final GetArticleController _getArticleController = Get.find<GetArticleController>();
  ArticleModel? articleModel;
  int? id;
  final t = 'ArticleDetailsScreen';
  String? downloadLink;
  @override
  void dispose() {
    ArticleDetailsData.relatedArticles = [];
    super.dispose();
  }

  @override
  void initState() {
    // model = ArticleModel.fromJson(Get.arguments);
    // _detailsController.articleId = model.id!;
    // pr(model.id, 'articleDetailsScreen - article id');
    // _detailsController.updateArticleModel(model);
    // _detailsController.getRelatedArticles();
    id = Get.arguments;
    if (id == null) {
      pr('id recieved in article details screen is null', t);
      return;
    }
    pr(id, '$t articleId');
    _getArticleController
        .getArticle(id: id!)
        .then((value) {
          articleModel = value;
          pr(articleModel, '$t - articleModel');
          _downloadLinkController
              .getDownloadlink(
                downloadLinkType: DownloadLinkType.article,
                id: articleModel?.id.toString() ?? '',
              )
              .then((value) {
                pr(value, '$t - downloadLink');
                return downloadLink = value;
              });
        })
        .then((_) {
          _detailsController.articleId = (articleModel?.id)!;
          // _detailsController.articleId = 83;
          _detailsController.getRelatedArticles();
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initScreenUtil(context);
    return GetBuilder<GetArticleController>(
      builder: (_) {
        return Scaffold(
          // appBar: QuranBar(_detailsController.selectedArticleModel.value.name!),
          appBar: QuranBar(articleModel?.name ?? ''),
          body:
              articleModel != null
                  ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.8),
                          child: Text(
                            // _detailsController.selectedArticleModel.value.name!,
                            articleModel?.name ?? '',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              fontSize: 18,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              String shareContent = ' ${articleModel?.name ?? ''}';
                              shareContent = '$shareContent\n-------------------------';
                              shareContent =
                                  '$shareContent\n${articleModel?.descriptionWithNoTags() ?? ''}';
                              Share.share(shareContent, subject: ' ${articleModel?.name ?? ''}');
                            },
                            icon: const Icon(Icons.share, color: primaryColor),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              border: Border.all(color: lightGray2, width: 1),
                            ),
                            margin: const EdgeInsets.only(top: 20, bottom: 20, right: 10, left: 10),
                            child: Scrollbar(
                              trackVisibility: true,
                              scrollbarOrientation: ScrollbarOrientation.right,
                              radius: const Radius.circular(10),
                              thumbVisibility: true,
                              thickness: 3,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  margin: const EdgeInsetsDirectional.only(start: 20, end: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Html(
                                        // data: _detailsController.selectedArticleModel.value.description!,
                                        data: cleanHtml(articleModel?.description ?? ''),
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
                                                  fontSize:
                                                      Get.find<SettingsController>().fontTypeEnum ==
                                                              FontType.normal
                                                          ? 14
                                                          : 18,
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

                                // Text(parseHtmlString(_detailsController.selectedArticleModel.value.description!),textAlign: TextAlign.justify,)
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryButton(
                              onPressed: () {
                                // pr(model.id);
                                // return;
                                Get.toNamed(
                                  AddCommentView.id,
                                  arguments: {"id": articleModel?.id, 'commentType': 'article'},
                                );
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
                          ],
                        ),
                        GetBuilder<ArticlesDetailsController>(
                          builder: (_) {
                            return Visibility(
                              visible:
                                  pr(
                                    ArticleDetailsData.relatedArticles,
                                    'test data in view',
                                  ).isNotEmpty,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'read_also'.tr,
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontFamily: "Almarai",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.only(left: 3, right: 3),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: ArticleDetailsData.relatedArticles.length,
                                      itemBuilder: (context, index) {
                                        return ElevatedButton(
                                          // onPressed: () => _detailsController
                                          //     .updateArticleModel(ArticleDetailsData.relatedArticles[index]),
                                          onPressed: () {
                                            Get.to(
                                              const ArticleDetailsScreen(),
                                              transition: Transition.fade,
                                              arguments:
                                                  ArticleDetailsData.relatedArticles[index].id,
                                              preventDuplicates: false,
                                            );
                                          },

                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.blueGrey,
                                            backgroundColor: Colors.white,
                                            padding: EdgeInsets.zero,
                                            elevation: 2,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 15,
                                            ),
                                            child: Text(
                                              ArticleDetailsData.relatedArticles[index].name,
                                              style: const TextStyle(fontFamily: 'Almarai'),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                  : _getArticleController.responseState == ResponseState.loading
                  ? const Center(child: CircularProgressIndicator())
                  : const Center(child: DefaultText('نأسف لحدوث خطا, نرجو المحاولة في وقت لاحق ')),
        );
      },
    );
  }

  String parseHtmlString(String htmlString) {
    return htmlString;
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}
