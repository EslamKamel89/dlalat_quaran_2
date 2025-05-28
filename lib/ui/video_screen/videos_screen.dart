import 'package:dlalat_quaran_new/ui/home_sura_screen.dart';
import 'package:dlalat_quaran_new/ui/video_screen/widgets/normal_videos_widget.dart';
import 'package:dlalat_quaran_new/ui/video_screen/widgets/series_videos_widget.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  static String id = '/VideosScreen';

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: QuranBar('الفيديوهات'.tr),
        body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(height: 5),
                TabBar(
                  indicatorColor: Colors.transparent,
                  tabs: [
                    TabButton(title: "الفيديوهات", selected: currentIndex == 0),
                    TabButton(title: "السلاسل", selected: currentIndex == 1),
                  ],
                  onTap: (value) {
                    currentIndex = value;
                    setState(() {});
                  },
                ),
                Expanded(
                  child: currentIndex == 0 ? const NormalVideosWidget() : const SeriesVideosWidget(),
                ),
              ],
            )),
      ),
    );
  }
}
