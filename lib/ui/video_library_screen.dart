// import 'package:dlalat_quaran_new/controllers/video_screen_controller.dart';
// import 'package:dlalat_quaran_new/utils/colors.dart';
// import 'package:dlalat_quaran_new/widgets/font_text.dart';
// import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
// import 'package:dlalat_quaran_new/widgets/search_widget.dart';
// import 'package:dlalat_quaran_new/widgets/video_item.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class VideoLibraryScreen extends StatelessWidget {
//   static String id = '/VideoLibraryScreen';
//   final TextEditingController _textController = TextEditingController();
//   String? catId;
//   final VideoScreenController _videoScreenController = Get.put(VideoScreenController());

//   VideoLibraryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     catId = Get.arguments["videoCatId"].toString();
//     _videoScreenController.getVideos(catId!);
//     _textController.addListener(() {
//       _videoScreenController.search(_textController.text.toString().toLowerCase());
//     });
//     // initScreenUtil(context);
//     return WillPopScope(
//       child: Scaffold(
//         backgroundColor: lightGray,
//         appBar: QuranBar('video_library'.tr),
//         body: Column(
//           children: [
//             AlMaraiText(18, Get.arguments["tagName"].toString()),
//             SearchWidget(_textController, null, () {
//               _videoScreenController.search(_textController.text.toString().toLowerCase());
//             }),
//             Expanded(
//                 child: Container(
//               margin: const EdgeInsets.only(left: 10, right: 10),
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                   boxShadow: [BoxShadow(color: mediumGray, blurRadius: 10)]),
//               child: Obx(() => _videoScreenController.filteredList.isNotEmpty
//                   ? GridView.count(
//                       crossAxisCount: 2,
//                       children: _videoScreenController.filteredList.map((e) {
//                         return VideoItem(
//                           videoModel: e,
//                         );
//                       }).toList(),
//                     )
//                   : Container(
//                       width: double.infinity,
//                       alignment: Alignment.center,
//                       child: AlMaraiText(14, 'لا يوجد بيانات'),
//                     )),
//             ))
//           ],
//         ),
//       ),
//       onWillPop: () async {
//         Get.delete<VideoScreenController>();
//         return true;
//       },
//     );
//   }
// }
