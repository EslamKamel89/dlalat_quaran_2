import 'dart:developer';

import 'package:dlalat_quaran_new/controllers/read_aya_controller.dart';
import 'package:dlalat_quaran_new/controllers/sura_screen_controller.dart';
import 'package:dlalat_quaran_new/ui/audio_player_widget.dart';
import 'package:dlalat_quaran_new/ui/player_bottom_widget.dart';
import 'package:dlalat_quaran_new/ui/short_explanation_index.dart';
import 'package:dlalat_quaran_new/utils/audio_download.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:dlalat_quaran_new/widgets/screen_util_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'new_single_sura_screen.dart';

late SuraScreenController _controller;
AudioDownload audioDownload = AudioDownload();

class SuraScreen extends StatelessWidget {
  const SuraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    initScreenUtil(context);
    log('suraScreen ${Get.arguments['page']}');
    int mPage = 1;
    try {
      mPage = int.parse(Get.arguments['page']);
      log('suraScreen mPage $mPage');
    } catch (e) {
      if (kDebugMode) {
        log('exception $e');
      }
    }
    currentPage.value = mPage;

    pageController = PageController(initialPage: mPage - 1, keepPage: false);
    currentPageNotifier = ValueNotifier<int>(currentPage.value);
    _controller = Get.put(SuraScreenController());
    return Obx(() => WillPopScope(
          onWillPop: () async {
            await audioPlayer.stop();

            selectedAyaId.value = '0';
            searchResultId.value = 0;
            selectAyaNo.value = '0';
            playerSuraCount.value = 2;
            playerSuraId.value = 0;
            currentPage.value = 1;
            currentReciter.value = '1';

            log('onWillPOP');
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.yellow[50],
            appBar: QuranBar(_controller.suraName.value),
            body: LinearProgressPageIndicatorDemo(),
          ),
        ));
  }
}

late ValueNotifier<int> currentPageNotifier;

//ignore: must_be_immutable
class LinearProgressPageIndicatorDemo extends StatefulWidget {
  LinearProgressPageIndicatorDemo({super.key});
  bool playerVisibility = true;

  @override
  _LinearProgressPageIndicatorDemoState createState() {
    return _LinearProgressPageIndicatorDemoState();
  }
}

late PageController pageController;

class _LinearProgressPageIndicatorDemoState extends State<LinearProgressPageIndicatorDemo> {
  int length = 604;
  ScrollController scrollController = ScrollController();
  ReadAyaController readAyaController = Get.find<ReadAyaController>();
  @override
  void initState() {
    readAyaController.scrollController = scrollController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildPageView(context),
          SizedBox(
            // height: 30.h,
            child: SliderTheme(
              data: const SliderThemeData(trackHeight: 2, thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
              child: SliderWidget(
                value: currentPageNotifier.value.toDouble(),
              ),
            ),
          ),
          GetBuilder<ReadAyaController>(builder: (controller) {
            return Visibility(
              visible: controller.showWidget,
              child: const AudioPlayerWidget(),
            );
          }),
          // SizedBox(
          //   // height: 80.h,
          //   child: Visibility(
          //     visible: false,
          //     child: Obx(
          //         () => PlayerBottomWidget(ayaId: int.parse(selectedAyaId.value), ayaNo: int.parse(selectAyaNo.value))),
          //   ),
          // ),
        ],
      ),
    );
  }

  // SuraScreenSinglePage(_controller, _currentPage)

  Widget _buildPageView(BuildContext context) {
    // log('message $_currentPage');
    // print('pages Length => ${pages.length}');
    return Container(
      color: Colors.black87,
      height: Get.height / 1.32,
      child: Obx(() => Center(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 2.5,
              child: PageView.builder(
                itemCount: length,
                physics: _controller.canSwipe.value ? null : const NeverScrollableScrollPhysics(),
                // scrollDirection: Axis.vertical,
                controller: pageController,
                itemBuilder: (BuildContext context, int index) {
                  return Center(child: NewSingleSuraScreen(index + 1));
                  // return Center(child: NewSingleSuraScreen(11));
                },

                onPageChanged: (int index) async {
                  await audioPlayer.stop();
                  if (_state.mounted) {
                    currentPageNotifier.value = index + 1;
                    currentPage.value = index + 1;
                    _state.widget.value = index + 1;
                    _state.setState(() {});

                    var sharedPreferences = await SharedPreferences.getInstance();
                    await sharedPreferences.setInt(savedPage, index + 1);
                    // ReadWriteValue(savedPage, 0).val = index+1;
                    // await  GetStorage().write(savedPage, index+1);
                  }
                  // _controller.getPage(index + 1);
                },
              ),
            ),
          )),
    );
  }
}

late _SliderWidgetState _state;

void changePosition(bool increase) {
  int newPosition = increase ? currentPageNotifier.value + 1 : currentPageNotifier.value - 1;
  if (_state.mounted) {
    currentPageNotifier.value = newPosition;
    currentPage.value = newPosition;
    // _state.widget.value = newPosition as double;
    pageController.jumpToPage(currentPage.value);
    _state.setState(() {});
  }
}

void jumpToPosition() {
  pageController.jumpToPage(currentPage.value);
  _state.setState(() {});
}

//ignore: must_be_immutable
class SliderWidget extends StatefulWidget {
  double value;

  SliderWidget({super.key, required this.value});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

//ignore: must_be_immutable
class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    _state = this;
    return Slider(
      value: widget.value,
      label: "الصفحة ${widget.value.toInt()}",
      max: 604,
      min: 1,
      divisions: 604,
      thumbColor: const Color(0xFF979CAA),
      activeColor: const Color(0xff78849e),
      inactiveColor: const Color(0xffb9c0cd),
      onChangeEnd: (value) {
        setState(() {
          widget.value = value;
          currentPageNotifier.value = (value).toInt();
          currentPage.value = value.toInt() - 1;
          pageController.jumpToPage(currentPage.value);
        });
      },
      onChanged: (double value) {
        setState(() {
          widget.value = value;
        });
      },
    );
  }
}
