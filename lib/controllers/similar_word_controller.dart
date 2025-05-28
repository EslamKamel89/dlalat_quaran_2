import 'dart:convert';

import 'package:dlalat_quaran_new/models/similar_word_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/is_internet_available.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimilarWordData {
  static List equalsList = [];
}

class SimilarWordController extends GetxController {
  ResponseState responseState = ResponseState.initial;
  final similarWordsEndpoint = "samewords";
  Future getSimilarWords() async {
    SimilarWordData.equalsList = [];
    if (await isInternetAvailable()) {
      await getSimilarWordsApi();
    } else {
      SimilarWordData.equalsList = await getSimilarWordsCached();
      update();
    }
  }

  Future getSimilarWordsApi() async {
    const t = 'getTagsApi - TagsScreenController';
    pr(t);
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl + similarWordsEndpoint;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    responseState = ResponseState.loading;
    update();
    try {
      final response = await dioConsumer.get(path);
      pr(response);
      pr(response.runtimeType);
      List data = response;
      pr(data, '$t - raw response');
      if (data.isEmpty) {
        responseState = ResponseState.success;
        pr('No tags found', t);
        SimilarWordData.equalsList = [];
        await cacheSimilarWords([]);
        update();
        return;
      }
      List<SimilarWordModel> words = data.map<SimilarWordModel>((json) => SimilarWordModel.fromJson(json)).toList();
      pr(words, '$t - parsed response');
      responseState = ResponseState.success;
      SimilarWordData.equalsList = words;
      await cacheSimilarWords(words);
      update();
      return;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseState.failed;
      SimilarWordData.equalsList = [];
      update();
      return;
    }
  }

  Future<List<SimilarWordModel>> getSimilarWordsCached() async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    return sharedPreferences
            .getStringList(similarWordsKey)
            ?.map((json) => SimilarWordModel.fromJson(jsonDecode(json)))
            .toList() ??
        [];
  }

  Future cacheSimilarWords(List<SimilarWordModel> words) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    await sharedPreferences.setStringList(
      similarWordsKey,
      words.map((word) => jsonEncode(word.toJson())).toList(),
    );
  }
}
