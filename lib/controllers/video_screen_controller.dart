// import 'package:dlalat_quaran_new/db/database_helper.dart';
// import 'package:get/get.dart';

// class VideoScreenController extends GetxController {
//   var videosList = [].obs;
//   var filteredList = [].obs;

//   void getVideos(String tag) async {
//     var allVideos = await DataBaseHelper.dataBaseInstance().categoryVideos(tag);
//     videosList.value = allVideos;
//     filteredList.value = allVideos;
//     update();
//   }

//   void search(String key) {
//     filteredList.value =
//         videosList.where(((x) => x.toString().contains(key))).toList();
//     update();
//   }
// }
