import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

//ignore: must_be_immutable
class VideoPlayerScreen extends StatelessWidget {
  static const String id = "/VideoPlayerScreen";
  final String videoId;

  const VideoPlayerScreen({Key? key, required this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('video_player_screen: video Id $videoId');
    return Container(
      width: Get.width,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: videoId.substring(videoId.length - 11),
              flags: const YoutubePlayerFlags(
                mute: false,
                autoPlay: true,
                disableDragSeek: false,
                loop: false,
                isLive: false,
                forceHD: false,
                enableCaption: true,
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 15,
            child: GestureDetector(
              child: Icon(
                Icons.close,
                size: 40,
                color: Colors.white,
              ),
              onTap: () => Get.back(),
            ),
          )
        ],
      ),
    );
  }
}
