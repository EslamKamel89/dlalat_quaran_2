import 'package:dlalat_quaran_new/controllers/video_controller.dart';
import 'package:dlalat_quaran_new/models/video_model.dart';
import 'package:dlalat_quaran_new/ui/video_screen/widgets/video_card.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NormalVideosWidget extends StatefulWidget {
  const NormalVideosWidget({super.key});

  @override
  State<NormalVideosWidget> createState() => _NormalVideosWidgetState();
}

class _NormalVideosWidgetState extends State<NormalVideosWidget> {
  final VideoController _videoController = Get.find<VideoController>()..getAllVideos();
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    _textEditingController.addListener(() {
      _videoController.search(_textEditingController.text.toString().toLowerCase());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SearchWidget(_textEditingController, null, () {
            _videoController.search(_textEditingController.text.toString().toLowerCase());
          }),
          GetBuilder<VideoController>(builder: (_) {
            if (_videoController.responseState == ResponseState.loading) {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            }
            if (VideoControllerData.filteredVideosList.isEmpty) {
              return const Expanded(child: Center(child: DefaultText('لا يوجد بيانات')));
            }
            return Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    VideoModel videoModel = VideoControllerData.filteredVideosList[index];
                    return VideoCard(videoModel: videoModel);
                  },
                  itemCount: VideoControllerData.filteredVideosList.length
                  //  > 1
                  //     ? 1
                  //     : VideoControllerData.filteredVideosList.length,
                  ),
            );
          }),
        ],
      ),
    );
  }
}
