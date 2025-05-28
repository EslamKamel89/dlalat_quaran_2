import 'dart:convert';

import 'package:dlalat_quaran_new/models/article_model.dart';
import 'package:dlalat_quaran_new/models/article_series_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/is_internet_available.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';

String _content =
    "الإسلام دين يدعو إلى السلام والتسامح. يعلمنا القرآن والسنة النبوية كيفية العيش بسلام مع الآخرين. الصلاة والصوم والزكاة والحج هي أركان الإسلام التي تعزز الروحانية والتقرب إلى الله. اتباع التعاليم الإسلامية يساهم في بناء مجتمع متماسك ومحب.";
String _desc =
    "الإسلام دين شامل يُرشد البشرية نحو السعادة والسلام. يؤكد على أهمية الأخلاق والقيم النبيلة. من خلال القرآن الكريم والسنة النبوية، يتعلم المسلمون كيفية تحقيق التوازن بين الدنيا والآخرة. الصلاة والصوم والزكاة والحج أركان تضمن تقرب الإنسان إلى الله وتعزيز روح التضامن والتآخي.";

abstract class ArticlesSeriesData {
  static List<ArticleSeriesModel> staticData = [
    ArticleSeriesModel(
      id: 1,
      name: 'رحلة الإيمان',
      content: _content,
      articles: [
        ArticleModel(
          id: 1,
          name: 'تأملات في القرآن',
          description: _desc,
        ),
        ArticleModel(
          id: 2,
          name: 'قصص الصحابة',
          description: _desc,
        ),
        ArticleModel(
          id: 3,
          name: 'دروس من الحديث',
          description: _desc,
        ),
      ],
    ),
    ArticleSeriesModel(
      id: 2,
      name: 'حكمة الأنبياء',
      content: _content,
      articles: [
        ArticleModel(
          id: 1,
          name: 'تأملات في القرآن',
          description: _desc,
        ),
        ArticleModel(
          id: 2,
          name: 'قصص الصحابة',
          description: _desc,
        ),
        ArticleModel(
          id: 3,
          name: 'دروس من الحديث',
          description: _desc,
        ),
      ],
    ),
    ArticleSeriesModel(
      id: 3,
      name: 'طرق إلى الجنة',
      content: _content,
      articles: [
        ArticleModel(
          id: 1,
          name: 'تأملات في القرآن',
          description: _desc,
        ),
        ArticleModel(
          id: 2,
          name: 'قصص الصحابة',
          description: _desc,
        ),
        ArticleModel(
          id: 3,
          name: 'دروس من الحديث',
          description: _desc,
        ),
      ],
    ),
  ];
  static List<ArticleSeriesModel> articleSeries = [];
  static List<ArticleSeriesModel> filteredList = [];
}

class ArticlesSeriesController extends GetxController {
  ResponseState responseState = ResponseState.initial;
  final articlesSeriesEndpoint = "article-series";
  int page = 0;
  int limit = 5000000;
  bool hasNextPage = true;

  Future<void> getArticleSeries() async {
    // if (await isInternetAvailable() && hasNextPage) {
    if (await isInternetAvailable()) {
      // pr('hasNextPage: $hasNextPage', t);
      await getArticleSeriesApi();
      await cacheArticleSeries();
      update();
    } else {
      await getCachedArticleSeries();
      update();
      return;
    }
  }

  Future<void> getArticleSeriesApi() async {
    const t = "getArticleSeries - ArticlesSeriesController";
    DioConsumer dioConsumer = serviceLocator();
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    String path = baseUrl + articlesSeriesEndpoint;
    // List<ArticleSeriesModel> tempArticleList = [];
    responseState = ResponseState.loading;
    update();
    try {
      responseState = ResponseState.loading;
      update();
      // final response = await dioConsumer.get("$path/${page * limit}/$limit/$deviceLocale");
      final response = await dioConsumer.get("$path/0/$limit/$deviceLocale");
      List data = jsonDecode(response);
      pr(data, '$t - raw response');
      if (data.isEmpty) {
        responseState = ResponseState.success;
        ArticlesSeriesData.articleSeries = [];
        ArticlesSeriesData.filteredList = [];
        update();
        return;
      }

      List<ArticleSeriesModel> articles =
          data.map<ArticleSeriesModel>((json) => ArticleSeriesModel.fromJson(json)).toList();
      pr(articles, '$t - parsed response');
      responseState = ResponseState.success;
      ArticlesSeriesData.articleSeries = articles;
      ArticlesSeriesData.filteredList = articles;
      update();
      return;

      //!
      // if (data.isEmpty) {
      //   responseState = ResponseState.success;
      //   tempArticleList = [];
      // } else {
      //   List<ArticleSeriesModel> articles =
      //       data.map<ArticleSeriesModel>((json) => ArticleSeriesModel.fromJson(json)).toList();
      //   pr(articles, '$t - parsed response');
      //   responseState = ResponseState.success;
      //   tempArticleList = articles;
      // }
      // if (tempArticleList.isEmpty) {
      //   hasNextPage = false;
      // } else {
      //   ArticlesSeriesData.articleSeries.addAll(tempArticleList);
      //   ArticlesSeriesData.filteredList = ArticlesSeriesData.articleSeries;
      //   update();
      //   hasNextPage = true;
      //   page++;
      // }
      // pr(hasNextPage, '$t - has next page');
      // pr('next page : $page', t);
      // update();
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseState.failed;
      update();
    }
  }

  Future<void> cacheArticleSeries() async {}
  Future<void> getCachedArticleSeries() async {}
  void search(String key) {
    ArticlesSeriesData.filteredList = ArticlesSeriesData.articleSeries;
    // filteredList.value = articlesList.where(((x) => x.toString().contains(key))).toList();
    ArticlesSeriesData.filteredList =
        ArticlesSeriesData.articleSeries.where(((x) => x.toString().contains(key))).toList();
    update();
  }

  @override
  void onClose() {
    ArticlesSeriesData.filteredList.clear();
    ArticlesSeriesData.articleSeries.clear();
    update();
    super.onClose();
  }
}
