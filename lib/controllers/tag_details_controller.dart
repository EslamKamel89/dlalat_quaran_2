import 'dart:convert';

import 'package:dlalat_quaran_new/models/tag_model.dart';
import 'package:dlalat_quaran_new/models/video_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';

abstract class TagDetailsData {
  static List relatedTags = [];
  static List tagVideos = [];
}

class TagDetailsController extends GetxController {
  int tagId = 0;
  // var relatedTags = [].obs;
  var selectedTagModel = TagModel().obs;
  // var tagVideos = <VideoModel>[].obs;

  ResponseState relatedTagsResponseState = ResponseState.initial;
  final relatedTagsEndpoint = "related-tags";
  ResponseState tagVideoResponseState = ResponseState.initial;
  final tagVideoEndpoint = "tag-video";

  void getRelatedTags() async {
    // TagDetailsData.relatedTags = await DataBaseHelper.dataBaseInstance().relatedTags(tagId);
    TagDetailsData.relatedTags = await getRelatedTagsApi(tagId);
    // TagDetailsData.relatedTags = [];
    update();
  }

  getTagVideos() async {
    // TagDetailsData.tagVideos = await DataBaseHelper.dataBaseInstance().tagsVideos(tagId);
    // TagDetailsData.tagVideos = await getTagVideosApi(tagId);
    TagDetailsData.tagVideos = [];
    update();
  }

  Future<List<TagModel>> getRelatedTagsApi(tagId) async {
    const t = 'getRelatedTagsApi - TagsDetailsController ';
    pr(tagId, '$t - tagId');
    DioConsumer dioConsumer = serviceLocator();
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    String path = '$baseUrl$relatedTagsEndpoint/$tagId/$deviceLocale';
    relatedTagsResponseState = ResponseState.loading;
    try {
      final response = await dioConsumer.get(path);
      List data = jsonDecode(response);
      pr(data, '$t - raw response');
      if (data.isEmpty) {
        relatedTagsResponseState = ResponseState.success;
        pr('No relatedTagsFound found', t);
        return [];
      }
      List<TagModel> tags = data.map<TagModel>((json) => TagModel.fromJson(json)).toList();
      pr(tags, '$t - parsed response');
      relatedTagsResponseState = ResponseState.success;
      return tags;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      relatedTagsResponseState = ResponseState.failed;
      // update();
      return [];
    }
  }

  Future<List<VideoModel>> getTagVideosApi(tagId) async {
    const t = 'getTagVideosApi - TagsDetailsController ';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl + tagVideoEndpoint;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    tagVideoResponseState = ResponseState.loading;
    try {
      // if (!(await isInternetAvailable())) {
      //   update();
      //   return await getCachedExplanation(id: id);
      // }
      final response = await dioConsumer.get(path, queryParameter: {
        "tag_id": tagId,
      });
      List data = jsonDecode(response);
      pr(data, '$t - raw response');
      if (data.isEmpty) {
        tagVideoResponseState = ResponseState.success;
        pr('No tag videos found', t);
        return [];
      }
      // await cacheExplanation(id: id, explanation: explanation);
      List<VideoModel> videos = data.map<VideoModel>((json) => VideoModel.fromJson(json)).toList();
      pr(videos, '$t - parsed response');
      tagVideoResponseState = ResponseState.success;
      return videos;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      tagVideoResponseState = ResponseState.failed;
      // update();
      return [];
    }
  }

  void updateTagModel(TagModel model) {
    selectedTagModel.value = model;
    tagId = model.id!;

    update();
    getRelatedTags();
  }

  @override
  void onClose() {
    TagDetailsData.relatedTags = [];
    TagDetailsData.tagVideos = [];
    super.onClose();
  }
}
