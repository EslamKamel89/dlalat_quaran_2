import 'dart:convert';

import 'package:dlalat_quaran_new/models/article_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/is_internet_available.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ArticlesData {
  static List articlesList = [];
  static List filteredList = [];
}

class ArticlesController extends GetxController {
  // var articlesList = [].obs;
  // var filteredList = [].obs;
  ResponseState responseState = ResponseState.initial;
  final articlesIndexEndpoint = "articles";
  final articlesSearchEndPoint = "articles-search";
  int page = 0;
  int limit = 500;
  bool hasNextPage = true;
  bool isSearching = false;
  DioConsumer dioConsumer = serviceLocator();
  Future<void> allArticles() async {
    // var list = await DataBaseHelper.dataBaseInstance().allArticles();
    if (await isInternetAvailable()) {
      await allArticlesApiPaginate();
      await cacheArticles(models: ArticlesData.articlesList);
    } else {
      int length = await getCachedArticlesDataLength() ?? 0;
      List<ArticleModel> cachedArticles = [];
      ArticleModel? tempArticleModel;
      for (var i = 0; i < length; i++) {
        tempArticleModel = await getCachedArtiles(index: i.toString());
        if (tempArticleModel == null) {
          continue;
        }
        cachedArticles.add(tempArticleModel);
      }
      responseState = ResponseState.success;
      ArticlesData.articlesList = cachedArticles;
      ArticlesData.filteredList = cachedArticles;
      update();
      return;
    }
    // articlesList.value = list;
    // filteredList.value = list;
    // update();
  }

  void search(String key) async {
    const t = 'search - ArticlesController ';
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    String path = baseUrl + articlesSearchEndPoint;
    List tempArticleList = [];
    if (key == '') {
      ArticlesData.filteredList = ArticlesData.articlesList;
      update();
      return;
    }
    if (key.length % 2 == 0 && !isSearching) {
      isSearching = true;
      try {
        responseState = ResponseState.loading;
        update();
        final response = await dioConsumer.get("$path/0/5/$deviceLocale/$key");
        isSearching = false;
        List data = jsonDecode(response);
        pr(data, '$t - raw response');
        if (data.isEmpty) {
          responseState = ResponseState.success;
          tempArticleList = [];
        } else {
          List<ArticleModel> articles = data.map<ArticleModel>((json) => ArticleModel.fromJson(json)).toList();
          pr(articles, '$t - parsed response');
          responseState = ResponseState.success;
          tempArticleList = articles;
        }
        ArticlesData.filteredList = [];
        ArticlesData.filteredList.addAll(tempArticleList);
        update();
      } on Exception catch (e) {
        pr('Exception occured: $e', t);
        isSearching = false;
        responseState = ResponseState.failed;
        update();
      }
      // filteredList.value = articlesList.where(((x) => x.toString().contains(key))).toList();
      // ArticlesData.filteredList = ArticlesData.articlesList.where(((x) => x.toString().contains(key))).toList();
      // update();
    }
  }

  Future allArticlesApiPaginate() async {
    const t = 'allArticlesApiPaginate - ArticlesController ';
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    String path = baseUrl + articlesIndexEndpoint;
    List tempArticleList = [];
    responseState = ResponseState.loading;
    update();
    try {
      responseState = ResponseState.loading;
      update();
      final response = await dioConsumer.get("$path/${page * limit}/$limit/$deviceLocale");
      List data = jsonDecode(response);
      pr(data, '$t - raw response');
      if (data.isEmpty) {
        responseState = ResponseState.success;
        tempArticleList = [];
      } else {
        List<ArticleModel> articles = data.map<ArticleModel>((json) => ArticleModel.fromJson(json)).toList();
        pr(articles, '$t - parsed response');
        responseState = ResponseState.success;
        tempArticleList = articles;
      }
      if (tempArticleList.isEmpty) {
        hasNextPage = false;
      } else {
        ArticlesData.articlesList.addAll(tempArticleList);
        ArticlesData.filteredList = ArticlesData.articlesList;
        update();
        hasNextPage = true;
        page++;
      }
      pr(hasNextPage, '$t - has next page');
      pr('next page : $page', t);
      update();
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseState.failed;
      update();
    }
  }

  Future allArticlesApi() async {
    const t = 'allArticlesApi - ArticlesController ';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl + articlesIndexEndpoint;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    ArticlesData.articlesList = [];
    ArticlesData.filteredList = [];
    List tempArticleList = [];
    bool continueLoop = true;
    int page = 0;
    int limit = 20;
    responseState = ResponseState.loading;
    update();
    try {
      do {
        responseState = ResponseState.loading;
        update();
        final response = await dioConsumer.get("$path/${page * limit}/$limit/$deviceLocale");
        List data = jsonDecode(response);
        pr(data, '$t - raw response');
        if (data.isEmpty) {
          responseState = ResponseState.success;
          update();
          tempArticleList = [];
        } else {
          List<ArticleModel> articles = data.map<ArticleModel>((json) => ArticleModel.fromJson(json)).toList();
          pr(articles, '$t - parsed response');
          responseState = ResponseState.success;
          update();
          tempArticleList = articles;
          ArticlesData.articlesList.addAll(articles);
          ArticlesData.filteredList = ArticlesData.articlesList;
        }

        if (tempArticleList.isEmpty) {
          continueLoop = false;
        } else {
          continueLoop = true;
          page++;
          pr('continue loop', t);
          pr('continueLoop : $continueLoop', t);
          pr('page : $page', t);
        }
        update();
      } while (continueLoop);
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseState.failed;
      update();
    }
  }

  Future<void> cacheArticles({required List models}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    await sharedPreferences.setInt('${articlesKey}length', models.length);
    for (var i = 0; i < models.length; i++) {
      await sharedPreferences.setString(articlesKey + i.toString(), jsonEncode(models[i].toJson()));
    }
  }

  Future<ArticleModel?> getCachedArtiles({required String index}) async {
    try {
      SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
      ArticleModel model = ArticleModel.fromJson(jsonDecode(sharedPreferences.getString(articlesKey + index) ?? ''));
      return model;
    } on Exception catch (e) {
      return null;
    }
  }

  Future<int?> getCachedArticlesDataLength() async {
    try {
      SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
      int? length = sharedPreferences.getInt('${articlesKey}length');
      return length;
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  void onClose() {
    // filteredList.clear();
    // articlesList.clear();
    ArticlesData.filteredList.clear();
    ArticlesData.articlesList.clear();
    update();
    super.onClose();
  }
}
