import 'package:dlalat_quaran_new/models/video_model.dart';
import 'package:dlalat_quaran_new/ui/video_player_screen.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoItem extends StatelessWidget {
  final VideoModel? videoModel;

  String _thumbnailLink() {
    return "https://img.youtube.com/vi/${videoModel!.url!.substring(videoModel!.url!.length - 11)}/0.jpg";
  }

  const VideoItem({super.key, this.videoModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.width / 2,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  color: Colors.black,
                  child: Image.network(
                    _thumbnailLink(),
                    fit: BoxFit.contain,
                    width: Get.width / 2,
                    height: Get.width / 2.3 - 50,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () =>
                      Get.to(VideoPlayerScreen(videoId: videoModel!.url!)),
                  child: Icon(
                    Icons.play_circle_fill,
                    color: const Color(0xff9dffffff),
                    size: Get.width / 7,
                  ),
                ),
              )
            ],
          ),
          Text(
            videoModel!.name!,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
