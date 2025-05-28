import 'dart:developer';
import 'dart:ui';

import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/tag_model.dart';
import '../utils/colors.dart';
import '../widgets/video_item.dart';

class DialogTagVideos extends StatelessWidget {
  TagModel tagModel;

  DialogTagVideos(this.tagModel, {super.key});

  final TagVideosController _controller = Get.put(TagVideosController());

  @override
  Widget build(BuildContext context) {
    _controller.getVideos(tagModel);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Material(
        elevation: 1,
        color: const Color(0x5dffffff),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Container(
          padding:
              const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          margin:
              const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: const Icon(Icons.arrow_back_outlined),
                    onTap: () {
                      Get.back();
                      Get.delete<TagVideosController>();
                    },
                  ),
                  Expanded(
                      child: Text(
                    tagModel.name(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'Almarai',
                        color: primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )),
                  const Icon(null),
                ],
              ),
              Container(
                color: Colors.grey,
                height: .5,
                margin: const EdgeInsets.only(top: 15, bottom: 15),
              ),
              Expanded(
                  child: Obx(() => GridView.count(
                        crossAxisCount: 2,
                        children: _controller.videosList.map((e) {
                          log('Video From Dadasd ${e.toString()}');
                          return VideoItem(
                            videoModel: e,
                          );
                        }).toList(),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class TagVideosController extends GetxController {
  var videosList = <VideoModel>[].obs;

  getVideos(TagModel tagId) async {
    videosList.value = await DataBaseHelper().tagsVideos(tagId.id!);
    update();
  }
}
