import 'package:dlalat_quaran_new/models/video_model.dart';
import 'package:dlalat_quaran_new/models/video_series_model.dart';
import 'package:dlalat_quaran_new/ui/video_screen/widgets/video_card.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:flutter/material.dart';

class VideoSeriesCard extends StatefulWidget {
  const VideoSeriesCard({super.key, required this.videoSeriesModel});
  final VideoSeriesModel videoSeriesModel;

  @override
  State<VideoSeriesCard> createState() => _VideoSeriesCardState();
}

class _VideoSeriesCardState extends State<VideoSeriesCard> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: <Widget>[
            ListTile(
              title: ArabicText(
                (widget.videoSeriesModel.name()),
                // style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: widget.videoSeriesModel.videos?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return VideoCard(videoModel: widget.videoSeriesModel.videos?[index] ?? VideoModel());
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
