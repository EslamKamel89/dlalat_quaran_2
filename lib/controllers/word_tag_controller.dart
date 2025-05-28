import 'dart:convert';

import 'package:dlalat_quaran_new/models/word_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/is_internet_available.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordTagController extends GetxController {
  final wordTagEndpoint = "pagetags";
  Future<Map<int, List>> geWordTagsMap({required List<int?> wordsId}) async {
    const t = 'geWordTagsMap - WordTagController';
    pr(wordsId, t);
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl + wordTagEndpoint;
    try {
      if (!(await isInternetAvailable())) {
        // pr('hello', t);
        if (wordsId.first == null) {
          update();
          return {};
        }
        await Future.delayed(const Duration(milliseconds: 1000));
        update();
        return await getCachedWordTag(id: wordsId.first!);
      }
      final response = await dioConsumer.post(
        path,
        data: {"words": pr(wordsId, t)},
      );

      Map<String, dynamic>? wordTag = jsonDecode(response);
      if (wordTag == null || wordTag.isEmpty) {
        update();
        return {};
      }
      Map<int, List> data = wordTag.map((key, value) => MapEntry(int.parse(key), value as List));
      pr(data, '$t - raw response');
      if (wordsId.first != null) {
        await cacheWordTag(id: wordsId.first!, wordTagMap: data);
      }
      update();
      return data;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      update();
      return {};
    }
  }

  List<int?> getWordIds({required List<List<WordModel>> pageLines}) {
    List<int> wordsId = [];
    for (List<WordModel> pageLine in pageLines) {
      for (WordModel word in pageLine) {
        int id;
        try {
          id = int.parse(word.word_id!);
          wordsId.add(id);
        } catch (_) {}
      }
    }
    // pr(wordsId, 'getWordsId - WordTagController');
    return wordsId;
  }

  Future<void> cacheWordTag({required int id, required Map<int, List> wordTagMap}) async {
    Map<String, List> wordTagMapJson = wordTagMap.map((key, value) => MapEntry(key.toString(), value));

    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    await sharedPreferences.setString(wordTagKey + id.toString(), jsonEncode(wordTagMapJson));
  }

  Future<Map<int, List>> getCachedWordTag({required int id}) async {
    try {
      SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
      String? jsonMap = sharedPreferences.getString(wordTagKey + id.toString());
      pr(id, 'wordTagKey get cache');
      pr(jsonMap, 'wordTagKey get cache');
      if (jsonMap == null) {
        return {};
      }
      Map<int, List> result =
          (jsonDecode(jsonMap) as Map<String, dynamic>).map((key, value) => MapEntry(int.parse(key), value as List));
      return result;
    } on Exception catch (_) {
      return {};
    }
  }

  void updateWordColor() {
    update();
  }
}
