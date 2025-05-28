import 'dart:convert';

import 'package:dlalat_quaran_new/models/tag_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/is_internet_available.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TagType { difference, meaning, equal }

String? tagTypeStr({required TagType tagType}) => {
      TagType.difference: 'difference',
      TagType.equal: 'equal',
      TagType.meaning: 'meaning',
    }[tagType];

abstract class TagsScreenData {
  static List tagsEqualsList = [];
  static List filteredEqualsList = [];
  static List tagsMeaningList = [];
  static List filteredMeaningList = [];
  static List tagsDifferenceList = [];
  static List filteredDifferenceList = [];
}

class TagsScreenController extends GetxController {
  var isLoading = true.obs;
  ResponseState responseState = ResponseState.initial;
  final getTagsEndpoint = "tag-type";
  void getTags({required TagType tagType}) async {
    // var list = await DataBaseHelper.dataBaseInstance().tagsIndex();
    pr(tagTypeStr(tagType: tagType));
    await getTagsApi(tagType: tagType);

    isLoading.value = false;
    update();
  }

  Future getTagsApi({required TagType tagType}) async {
    final t = 'getTagsApi - TagsScreenController - $tagType ';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl + getTagsEndpoint;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    responseState = ResponseState.loading;
    update();
    try {
      if (!(await isInternetAvailable())) {
        int length = await getCachedTagsDataLength(tagType: tagType) ?? 0;
        List<TagModel> cachedTags = [];
        TagModel? tempTagModel;
        for (var i = 0; i < length; i++) {
          tempTagModel = await getCachedTag(index: i.toString(), tagType: tagType);
          if (tempTagModel == null) {
            continue;
          }
          cachedTags.add(tempTagModel);
        }
        responseState = ResponseState.success;
        setTagsList(tagType: tagType, tags: cachedTags);
        update();
        return;
      }
      final response = await dioConsumer.get("$path/${tagTypeStr(tagType: tagType)}");
      List data = jsonDecode(response);
      pr(data, '$t - raw response');
      if (data.isEmpty) {
        responseState = ResponseState.success;
        pr('No tags found', t);
        setTagsList(tagType: tagType, tags: []);
        update();
        return;
      }
      // await cacheExplanation(id: id, explanation: explanation);
      List<TagModel> tags = data.map<TagModel>((json) => TagModel.fromJson(json)).toList();
      pr(tags, '$t - parsed response');
      responseState = ResponseState.success;
      cacheTags(models: tags, tagType: tagType);
      setTagsList(tagType: tagType, tags: tags);
      update();
      return;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseState.failed;
      setTagsList(tagType: tagType, tags: []);
      update();
      return;
    }
  }

  void search({required String key, required TagType tagType}) {
    switch (tagType) {
      case TagType.difference:
        TagsScreenData.filteredDifferenceList = TagsScreenData.tagsDifferenceList;
        TagsScreenData.filteredDifferenceList = TagsScreenData.tagsDifferenceList.where(((x) {
          return x.toString().toLowerCase().contains(key.toLowerCase());
        })).toList();
        update();
        break;
      case TagType.meaning:
        TagsScreenData.filteredMeaningList = TagsScreenData.tagsMeaningList;
        TagsScreenData.filteredMeaningList = TagsScreenData.tagsMeaningList.where(((x) {
          return x.toString().toLowerCase().contains(key.toLowerCase());
        })).toList();
        update();
        break;
      case TagType.equal:
        TagsScreenData.filteredEqualsList = TagsScreenData.tagsEqualsList;
        TagsScreenData.filteredEqualsList = TagsScreenData.tagsEqualsList.where(((x) {
          return x.toString().toLowerCase().contains(key.toLowerCase());
        })).toList();
        update();
        break;
    }
  }

  Future<void> cacheTags({required List<TagModel> models, required TagType tagType}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    await sharedPreferences.setInt('$tagsKey lenght ${tagTypeStr(tagType: tagType)!}', models.length);
    for (var i = 0; i < models.length; i++) {
      await sharedPreferences.setString('$tagsKey ${tagTypeStr(tagType: tagType)!} $i', jsonEncode(models[i].toJson()));
    }
  }

  Future<TagModel?> getCachedTag({required String index, required TagType tagType}) async {
    try {
      SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
      pr(tagsKey + index, 'debug get cahced key');
      TagModel model = TagModel.fromJson(
          jsonDecode(sharedPreferences.getString('$tagsKey ${tagTypeStr(tagType: tagType)!} $index') ?? ''));

      return pr(model, 'deubug cahce resutl model');
    } on Exception catch (e) {
      pr(e.toString(), 'Exception occured');
      return null;
    }
  }

  Future<int?> getCachedTagsDataLength({required TagType tagType}) async {
    try {
      SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
      int? length = sharedPreferences.getInt('$tagsKey lenght ${tagTypeStr(tagType: tagType)!}');
      return length;
    } on Exception catch (_) {
      return null;
    }
  }

  void setTagsList({required TagType tagType, required List<TagModel> tags}) {
    switch (tagType) {
      case TagType.difference:
        TagsScreenData.tagsDifferenceList = tags;
        TagsScreenData.filteredDifferenceList = tags;
        break;
      case TagType.meaning:
        TagsScreenData.tagsMeaningList = tags;
        TagsScreenData.filteredMeaningList = tags;
        break;
      case TagType.equal:
        TagsScreenData.tagsEqualsList = tags;
        TagsScreenData.filteredEqualsList = tags;
        break;
    }
  }
}
