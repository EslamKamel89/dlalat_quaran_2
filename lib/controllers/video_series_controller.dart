import 'dart:convert';

import 'package:dlalat_quaran_new/dialogs/custom_snack_bar.dart';
import 'package:dlalat_quaran_new/models/video_series_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/is_internet_available.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';

String _content =
    "الإسلام دين يدعو إلى السلام والتسامح. يعلمنا القرآن والسنة النبوية كيفية العيش بسلام مع الآخرين. الصلاة والصوم والزكاة والحج هي أركان الإسلام التي تعزز الروحانية والتقرب إلى الله. اتباع التعاليم الإسلامية يساهم في بناء مجتمع متماسك ومحب.";
String _url = "https://www.youtube.com/watch?v=zSH15dIl7D0";

abstract class VideosSeriesData {
  // static List<VideoSeriesModel> staticData = [
  //   VideoSeriesModel(
  //     id: 1,
  //     name: 'رحلة الإيمان',
  //     content: _content,
  //     videos: [
  //       VideoModel(
  //         id: 1,
  //         name: 'تأملات في القرآن',
  //         url: _url,
  //       ),
  //       VideoModel(
  //         id: 2,
  //         name: 'قصص الصحابة',
  //         url: _url,
  //       ),
  //       VideoModel(
  //         id: 3,
  //         name: 'دروس من الحديث',
  //         url: _url,
  //       ),
  //     ],
  //   ),
  //   VideoSeriesModel(
  //     id: 2,
  //     name: 'حكمة الأنبياء',
  //     content: _content,
  //     videos: [
  //       VideoModel(
  //         id: 1,
  //         name: 'تأملات في القرآن',
  //         url: _url,
  //       ),
  //       VideoModel(
  //         id: 2,
  //         name: 'قصص الصحابة',
  //         url: _url,
  //       ),
  //       VideoModel(
  //         id: 3,
  //         name: 'دروس من الحديث',
  //         url: _url,
  //       ),
  //     ],
  //   ),
  //   VideoSeriesModel(
  //     id: 3,
  //     name: 'طرق إلى الجنة',
  //     content: _content,
  //     videos: [
  //       VideoModel(
  //         id: 1,
  //         name: 'تأملات في القرآن',
  //         url: _url,
  //       ),
  //       VideoModel(
  //         id: 2,
  //         name: 'قصص الصحابة',
  //         url: _url,
  //       ),
  //       VideoModel(
  //         id: 3,
  //         name: 'دروس من الحديث',
  //         url: _url,
  //       ),
  //     ],
  //   ),
  // ];

  static List<VideoSeriesModel> videoSeries = [];
  static List<VideoSeriesModel> filteredList = [];
}

class VideosSeriesController extends GetxController {
  ResponseState responseState = ResponseState.initial;
  final videosSeriesEndpoint = "video-series";
  int page = 0;
  int limit = 50000;
  bool hasNextPage = true;

  Future<void> getVideoSeries() async {
    const t = "getVideoSeriesPagination - VideosSeriesController";
    VideosSeriesData.videoSeries = [];
    VideosSeriesData.filteredList = [];
    // responseState = ResponseState.loading;
    // update();
    // await Future.delayed(const Duration(seconds: 1));
    // VideosSeriesData.videoSeries = VideosSeriesData.staticData;
    // VideosSeriesData.filteredList = VideosSeriesData.staticData;
    // responseState = ResponseState.success;
    // update();
    // return;
    //?
    //!
    if (await isInternetAvailable()) {
      if (hasNextPage) {
        pr('hasNextPage: $hasNextPage', t);
        await getVideoSeriesApi();
        // await cacheVideoSeries();
      }
      update();
    } else {
      // await getCachedVideoSeries();
      showCustomSnackBarNoInternet();
      update();
      return;
    }
  }

  Future<void> getVideoSeriesApi() async {
    const t = "getVideoSeries - VideosSeriesController";
    DioConsumer dioConsumer = serviceLocator();
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    String path = baseUrl + videosSeriesEndpoint;
    // List<VideoSeriesModel> tempVideoList = [];
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
        VideosSeriesData.videoSeries = [];
        VideosSeriesData.filteredList = [];
        update();
        return;
      }
      List<VideoSeriesModel> videos = data.map<VideoSeriesModel>((json) => VideoSeriesModel.fromJson(json)).toList();
      pr(videos, '$t - parsed response');
      responseState = ResponseState.success;
      VideosSeriesData.videoSeries = videos;
      VideosSeriesData.filteredList = videos;
      update();
      return;

      // if (data.isEmpty) {
      //   responseState = ResponseState.success;
      //   tempVideoList = [];
      // } else {
      //   List<VideoSeriesModel> Videos = data.map<VideoSeriesModel>((json) => VideoSeriesModel.fromJson(json)).toList();
      //   pr(Videos, '$t - parsed response');
      //   responseState = ResponseState.success;
      //   tempVideoList = Videos;
      // }
      // if (tempVideoList.isEmpty) {
      //   hasNextPage = false;
      // } else {
      //   VideosSeriesData.videoSeries.addAll(tempVideoList);
      //   VideosSeriesData.filteredList = VideosSeriesData.videoSeries;
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

  Future<void> cacheVideoSeries() async {}
  Future<void> getCachedVideoSeries() async {}
  void search(String key) {
    VideosSeriesData.filteredList = VideosSeriesData.videoSeries;
    // filteredList.value = VideosList.where(((x) => x.toString().contains(key))).toList();
    VideosSeriesData.filteredList = VideosSeriesData.videoSeries.where(((x) => x.toString().contains(key))).toList();
    update();
  }

  @override
  void onClose() {
    VideosSeriesData.filteredList.clear();
    VideosSeriesData.videoSeries.clear();
    update();
    super.onClose();
  }
}
