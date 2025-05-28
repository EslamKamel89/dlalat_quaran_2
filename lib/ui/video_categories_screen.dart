// import 'dart:io';

// import 'package:dlalat_quaran_new/db/database_helper.dart';
// import 'package:dlalat_quaran_new/models/video_category.dart';
// import 'package:dlalat_quaran_new/ui/video_library_screen.dart';
// import 'package:dlalat_quaran_new/utils/audio_folders.dart';
// import 'package:dlalat_quaran_new/utils/constants.dart';
// import 'package:dlalat_quaran_new/widgets/white_container.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// import '../utils/colors.dart';
// import '../widgets/quran_toolbar.dart';

// class VideoCategoriesScreen extends StatelessWidget {
//   static String id = '/VideoCategoriesScreen';
//   final VideoCategoriesController _controller = Get.put(VideoCategoriesController());

//   VideoCategoriesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     _controller.getCats();
//     // initScreenUtil(context);
//     return WillPopScope(
//         onWillPop: () async {
//           return true;
//         },
//         child: Scaffold(
//           backgroundColor: lightGray,
//           appBar: QuranBar('video_categories'.tr),
//           body: Container(
//             margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//             child: Obx(() => ListView.builder(
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(5),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent, padding: const EdgeInsets.all(0)),
//                         onPressed: () => Get.to(VideoLibraryScreen(), arguments: {
//                           "videoCatId": _controller.catList[index].id.toString(),
//                           "tagName": _controller.catList[index].toString()
//                         }),
//                         child: WhiteContainer(
//                             height: 70,
//                             radius: 5,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 _controller.catList[index].icon == null
//                                     ? Image.asset(logoMedium)
//                                     : Image.file(File(
//                                         '${GetStorage().read(iconsPath)}/${_controller.catList.value[index].icon!.replaceAll('icon/', '')}')),
//                                 const SizedBox(
//                                   width: 20,
//                                 ),
//                                 Text(
//                                   _controller.catList[index].nameAr!,
//                                   style: const TextStyle(color: Colors.black),
//                                 )
//                               ],
//                             )),
//                       ),
//                     );
//                   },
//                   itemCount: _controller.catList.length,
//                 )),
//           ),
//         ));
//   }
// }

// class VideoCategoriesController extends GetxController {
//   var catList = <VideoCategory>[].obs;

//   void getCats() async {
//     catList.value = await DataBaseHelper.dataBaseInstance().videosCategories();
//     for (var element in catList.value) {
//       File? file = File('${GetStorage().read(iconsPath)}/${element.icon!.replaceAll('icon/', '')}');
//       if (!await file.exists()) {
//         await AudioFolders().downloadIcon("https://qurantoall.com/control-panel/storage/${element.icon}");
//       }
//     }
//     update();
//   }
// }
