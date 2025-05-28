import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/video_model.dart';
import '../ui/video_player_screen.dart';

class VideoItemDialog extends StatelessWidget {
  final VideoModel? videoModel;

  String _thumbnailLink() {
    return "https://img.youtube.com/vi/${videoModel!.url!.substring(videoModel!.url!.length - 11)}/0.jpg";
  }

  const VideoItemDialog({Key? key, this.videoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  child: Image.network(
                    _thumbnailLink(),
                    fit: BoxFit.contain,
                    width: 120,
                    height: 120,
                  ),
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: const Color(0xff9dffffff),
                    size: 100 / 2,
                  ),
                  customBorder: const CircleBorder(),
                  onTap: () {
                    log('asdasdasdasdas');
                    Get.to(VideoPlayerScreen(videoId: videoModel!.url!));
                  },
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
