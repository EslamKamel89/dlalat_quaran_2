import 'package:dlalat_quaran_new/controllers/video_series_controller.dart';
import 'package:dlalat_quaran_new/models/video_series_model.dart';
import 'package:dlalat_quaran_new/ui/video_screen/widgets/video_series_card.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeriesVideosWidget extends StatefulWidget {
  const SeriesVideosWidget({super.key});

  @override
  State<SeriesVideosWidget> createState() => _SeriesVideosWidgetState();
}

class _SeriesVideosWidgetState extends State<SeriesVideosWidget> {
  final VideosSeriesController _videoController = Get.find<VideosSeriesController>()..getVideoSeries();
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    _videoController.getVideoSeries();
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
          GetBuilder<VideosSeriesController>(builder: (_) {
            if (_videoController.responseState == ResponseState.loading) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (_videoController.responseState == ResponseState.success && VideosSeriesData.filteredList.isEmpty) {
              return const Expanded(
                child: Center(
                  child: ArabicText('لا يوجد بيانات'),
                ),
              );
            }
            return Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    VideoSeriesModel videoSeriesModel = VideosSeriesData.filteredList[index];
                    return VideoSeriesCard(videoSeriesModel: videoSeriesModel);
                  },
                  itemCount: VideosSeriesData.filteredList.length),
            );
          }),
        ],
      ),
    );
  }
}
