import 'dart:convert';

import 'package:dlalat_quaran_new/models/word_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/is_internet_available.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CorrectWordData {
  static List<WordModel> replaceWords = [];
}

class CorrectWordController extends GetxController {
  ResponseState responseState = ResponseState.initial;
  final similarWordsEndpoint = "emptyapi";
  Future getCorrectWords() async {
    CorrectWordData.replaceWords = [];
    if (await isInternetAvailable()) {
      await getCorrectWordsApi();
    } else {
      CorrectWordData.replaceWords = await getCorrectWordsCached();
      update();
    }
  }

  Future getCorrectWordsApi() async {
    const t = 'getCorrectWordsApi - CorrectWordController';
    pr(t);
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl + similarWordsEndpoint;
    responseState = ResponseState.loading;
    update();
    try {
      final response = await dioConsumer.get(path);
      pr(response);
      List data = response;
      pr(data, '$t - raw response');
      if (data.isEmpty) {
        responseState = ResponseState.success;
        pr('No correct words found', t);
        CorrectWordData.replaceWords = [];
        await cacheCorrectWords([]);
        update();
        return;
      }
      List<WordModel> words = data.map<WordModel>((json) => WordModel.fromJson(json)).toList();
      pr(words, '$t - parsed response');
      responseState = ResponseState.success;
      CorrectWordData.replaceWords = words;
      await cacheCorrectWords(words);
      update();
      return;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseState.failed;
      CorrectWordData.replaceWords = [];
      update();
      return;
    }
  }

  Future<List<WordModel>> getCorrectWordsCached() async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    return sharedPreferences
            .getStringList(correctWordsKey)
            ?.map((json) => WordModel.fromJson(jsonDecode(json)))
            .toList() ??
        [];
  }

  Future cacheCorrectWords(List<WordModel> words) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    await sharedPreferences.setStringList(
      correctWordsKey,
      words.map((word) => jsonEncode(word.toJson())).toList(),
    );
  }
}
