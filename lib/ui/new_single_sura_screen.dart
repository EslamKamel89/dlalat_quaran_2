import 'package:audioplayers/audioplayers.dart';
import 'package:dlalat_quaran_new/controllers/read_aya_controller.dart';
import 'package:dlalat_quaran_new/controllers/word_tag_controller.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/TagWordModel.dart';
import 'package:dlalat_quaran_new/models/reciters_model.dart';
import 'package:dlalat_quaran_new/models/word_model.dart';
import 'package:dlalat_quaran_new/ui/player_bottom_widget.dart';
import 'package:dlalat_quaran_new/ui/setting_screen.dart';
import 'package:dlalat_quaran_new/ui/short_explanation_index.dart';
import 'package:dlalat_quaran_new/ui/single_word_widget.dart';
import 'package:dlalat_quaran_new/ui/sura_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/format_arabic_number.dart';
import 'package:dlalat_quaran_new/utils/juz_names.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/widgets/explain_dialog.dart';
import 'package:dlalat_quaran_new/widgets/show_custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/audio_folders.dart';
import 'dialog_word_tag.dart';

const _t = 'new single sura screen';
NewSingleSuraScreenState? parentWidget;

Color? normalFontColor;
Color? tagWordsColor;
Color? readWordsColor;
Color? bgColor;

class NewSingleSuraScreen extends StatefulWidget {
  final int page;

  // ignore: use_key_in_widget_constructors
  NewSingleSuraScreen(this.page);
  @override
  final GlobalKey<NewSingleSuraScreenState> key = GlobalKey<NewSingleSuraScreenState>();

  @override
  NewSingleSuraScreenState createState() => NewSingleSuraScreenState();
}

class NewSingleSuraScreenState extends State<NewSingleSuraScreen> {
  List<List<WordModel>> pageLines = [];
  List<int?> wordsId = [];
  Map<int, List> wordTagMap = {};
  String suraName = '';
  String juz = '';

  String reciterId = '0';
  String fontWeight = GetStorage().read(fontTypeKey) ?? FontType.normal.name;
  TagWordModel? tagWordModel;
  WordTagController wordTagController = Get.find<WordTagController>();
  void getColors() async {
    // if (normalFontColor == null) {
    normalFontColor = colors[await DataBaseHelper.dataBaseInstance().getColor(KnormalFontColor)];
    // tagWordsColor = colors[await DataBaseHelper.dataBaseInstance().getColor(KtagWordsColor)];
    tagWordsColor = Colors.red;
    readWordsColor = colors[await DataBaseHelper.dataBaseInstance().getColor(KreadWordsColor)];
    bgColor = colors[await DataBaseHelper.dataBaseInstance().getColor(KpageBg)];
    // }
  }

  void getPageLines() async {
    var conf = AudioContext(
      android: const AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.gain,
      ),
      iOS: AudioContextIOS(
        // defaultToSpeaker: true,
        category: AVAudioSessionCategory.playback,
        // options: <AVAudioSessionOptions>[],
      ),
    );
    // GlobalPlatformInterface.instance.setGlobalAudioContext(conf);

    var read = GetStorage().read('${widget.page}Full').toString();
    getCurrentReciter();
    if (read == 'null' || true) {
      pageLines = await DataBaseHelper.dataBaseInstance().getFull(widget.page);
      //? get word tag
      wordsId = wordTagController.getWordIds(pageLines: pageLines);
      wordTagController.geWordTagsMap(wordsId: wordsId).then((value) => wordTagMap = value);
      GetStorage().write('${widget.page}Full', pageLines);
      juz = await DataBaseHelper.dataBaseInstance().getJuz(pageLines[0][0].ayaNo!, int.parse(pageLines[0][0].sura!));
      suraName = await DataBaseHelper.dataBaseInstance().getSuraByPage(int.parse(pageLines[0][0].sura!));
    } else {
      pageLines = GetStorage().read('${widget.page}Full');
      suraName = await DataBaseHelper.dataBaseInstance().getSuraByPage(int.parse(pageLines[0][0].sura!));
      juz = await DataBaseHelper.dataBaseInstance().getJuz(pageLines[0][0].ayaNo!, int.parse(pageLines[0][0].sura!));
    }
    // log('JJuze name ${juzArName(juz)}');
    Future.delayed(Duration.zero, () async {
      if (mounted) {
        setState(() {});
      }
    });
    audioDownload.downloadPage(widget.page);
  }

  var containerHeight = Get.height / 1.4;

  Widget columnWidget(BuildContext mContext) {
    List<Widget> widgets = [];

    for (var x = 0; x < pageLines.length; x++) {
      List<Widget> children = [];

      for (var j = 0; j < pageLines[x].length; j++) {
        if (pageLines[x][j].firstAya()) {
          widgets.add(
            !isSmallPage()
                ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/sura_title_bg.png',
                      height: isSmallScreen ? 25 : 30,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    Center(
                      child: Text(
                        pageLines[x][j].suraName!,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontFamily: 'Mcs',
                          color: normalFontColor,
                          fontWeight: FontWeight.w600,
                          fontSize: isSmallScreen ? 15 : 18,
                        ),
                      ),
                    ),
                  ],
                )
                : const SizedBox(),
          );

          if (pageLines[x][j].sura != "9" && pageLines[x][j].sura != "1") {
            widgets.add(
              Image.asset("assets/images/in_the_name.png", color: normalFontColor, height: isSmallScreen ? 20 : 25),
            );
          }
        }
        var fontSize = widget.page == 1 || widget.page == 2 ? containerHeight / 24 : containerHeight / 26;
        if (pageLines[x][j].word_ar! != ' ') {
          // if (isNumeric(pageLines[x][j].word_ar!)) {
          //   children.add(AyaNo(pageLines[x][j].word_ar!));
          // } else {

          children.add(
            GestureDetector(
              child: Builder(
                builder: (context) {
                  tagWordModel = null;
                  return GetBuilder<WordTagController>(
                    builder: (_) {
                      return Builder(
                        builder: (context) {
                          return SingleWordWidget(
                            wordModel: pageLines[x][j],
                            fontSize: fontSize,
                            fontFamilyNum: widget.page,
                            wordTagMap: wordTagMap,
                            fontWeight: fontWeight,
                          );
                        },
                      );
                    },
                  );
                },
              ),
              onTap: () {
                // log('videos \nWordVideo ${pageLines[x][j].wordVideo}\n Tag ${pageLines[x][j].tagId}');
                // pr(pageLines[x][j]);
                // pr(pageLines[x][j].word_id);
                // pr(pageLines[x][j].ayaId);
                // pr(pageLines[x][j].word_id == '22150');
                // pr(pageLines[x][j].ayaId?.trim() == '988');
                // pr(pageLines[x][j].word_id == '22150' && pageLines[x][j].ayaId?.trim() == '988');
                // pr(pageLines[x][j].word_ar);
                // pr(HtmlUnescape().convert(pageLines[x][j].word_ar!));
                // return;
                // if (pageLines[x][j].tagId != 'null') {
                if (wordTagMap[int.parse(pageLines[x][j].word_id ?? '0')] != null) {
                  // Get.dialog(DialogWordTag(tagId: pageLines[x][j].tagId!, wordId: pageLines[x][j].word_id!));
                  Get.dialog(
                    DialogWordTag(
                      // tagId: wordTagMap[int.parse(pageLines[x][j].word_id ?? '0')].toString(),
                      tagId: pr(getTagId(pageLines[x][j], wordTagMap).toString(), '$_t - tagId '),
                      wordId: pr(pageLines[x][j].word_id!, '$_t - wordId'),
                    ),
                  );
                }
                // else if(pageLines[x][j].wordVideo != 'null'){
                //   Get.to(() => VideoPlayerScreen(videoId: pageLines[x][j].wordVideo!));
                //
                // }
                else {
                  Get.dialog(
                    ExplainDialog(
                      ayaKey: pageLines[x][j].ayaId.toString(),
                      videoId: pageLines[x][j].videoId.toString(),
                      suraName: pageLines[x][j].suraName,
                      ayaNumber: pageLines[x][j].ayaNo,
                    ),
                  );
                }
              },
              onLongPress: () async {
                // pr(pageLines[x][j].ayaId, 'aya no');
                // pr(pageLines[x][j].suraName, 'aya no');
                // return;
                ShareOrReadAction? action = await showCustomDialog(context);
                if (action == ShareOrReadAction.read) {
                  Get.find<ReadAyaController>().playAyaById(
                    int.parse(pageLines[x][j].ayaId ?? '0'),
                    int.parse(pageLines[x][j].sura ?? '0'),
                  );
                }
                if (action == ShareOrReadAction.share) {
                  String ayahAr = await DataBaseHelper.dataBaseInstance().getAyaTextArByAyaId(
                    int.parse(pageLines[x][j].ayaId ?? '0'),
                  );
                  String shareContent = ayahAr;
                  shareContent =
                      '$shareContent\n الأية رقم ${formatArabicNumber(pageLines[x][j].ayaNo) ?? ''} في ${pageLines[x][j].suraName}\n';
                  // shareContent =
                  // '$shareContent\n${DataBaseHelper.dataBaseInstance().parseHtmlString(explanation ?? '')}';
                  Share.share(
                    shareContent,
                    subject:
                        '$shareContent\n الأية رقم ${formatArabicNumber(pageLines[x][j].ayaNo) ?? ''} في ${pageLines[x][j].suraName}\n',
                  );
                }

                return;
                // var ayaText = await DataBaseHelper.dataBaseInstance().getAyaTextAr(
                //     int.parse(pageLines[x][j].sura!), pageLines[x][j].ayaNo ?? 0, int.parse(pageLines[x][j].ayaId!));
                // Get.dialog(DialogListenShowAya(
                //   x: x,
                //   j: j,
                //   newSingleSuraScreenState: widget.key,
                //   ayaText: ayaText,
                //   ayaNum: "${pageLines[x][j].ayaNo ?? 0}",
                //   suraText: suraName,
                // ));
              },
            ),
          );
          // }
        }
      }

      widgets.add(
        Row(
          mainAxisAlignment: pageLines.length > 9 ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
          children: children,
        ),
      );
    }

    return OverflowBox(
      maxHeight: Get.width < 600 ? null : double.infinity,
      child: Column(
        mainAxisAlignment:
            widget.page == 1 || widget.page == 2 ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.,
        children: widgets,
      ),
    );
  }

  void listenSound(int x, int j) async {
    await audioPlayer.stop();
    playerSuraId.value = int.parse(pageLines[x][j].sura!);
    playerSuraCount.value = await DataBaseHelper.dataBaseInstance().suraCount(int.parse(pageLines[x][j].sura!));
    // playerSuraId.value = int.parse(pageLines[x][j].sura!);

    selectAyaNo.value =
        selectAyaNo.value == pageLines[x][j].ayaNo!.toString() ? "0" : pageLines[x][j].ayaNo!.toString();

    selectedAyaId.value = selectedAyaId.value == pageLines[x][j].ayaId! ? "0" : pageLines[x][j].ayaId!;
    var sharedPref = await SharedPreferences.getInstance();
    var selectedReciterId = sharedPref.getString(reciterKey) ?? "1";
    String fullPath = await AudioFolders().generatePath(
      selectedReciterId.toString(),
      playerSuraId.value.toString(),
      selectAyaNo.value,
    );
    setState(() {});
    if (parentWidget!.mounted) {
      parentWidget!.setState(() {});
    }

    // log('fully path =>  $fullPath');
    try {
      await audioPlayer.play(DeviceFileSource(fullPath));
    } catch (e) {
      // log('Player Exception $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // initScreenUtil(context);
    // containerHeight = 450.h;
    // pr('hello world', 'sync manager');
    // DataBaseHelper.dataBaseInstance().getTagWord(1);
    getColors();
    parentWidget = this;
    if (pageLines.isEmpty) {
      getPageLines();
    }

    // log("NewSingleSuraScreenLogME");
    return Container(
      color: Colors.white,
      // height: double.infinity,
      child: Column(
        children: [
          Container(
            // color: Colors.yellow[50],
            padding: const EdgeInsets.only(left: 15, right: 15),
            // height: isSmallScreen ? 22 : 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    suraName,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontFamily: 'kitab',
                      fontSize: isSmallScreen ? Get.width / 25 : Get.width / 22,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/icons/page_bg.png', height: isSmallScreen ? 25 : 22),
                      Center(
                        child:
                        // Text('${screenController.newPage.value}'))
                        Text(
                          _convertToArabicNumber(widget.page),
                          style: TextStyle(
                            fontFamily: 'kitab',
                            fontSize: isSmallScreen ? Get.width / 25 : Get.width / 22,
                            fontStyle: FontStyle.normal,
                          ),
                          textScaleFactor: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    // 'الجزء${Tafqeet.convert(screenController.juz.value)}',
                    juzArName(juz),
                    style: TextStyle(
                      fontFamily: 'kitab',
                      fontSize: isSmallScreen ? Get.width / 25 : Get.width / 22,
                      fontStyle: FontStyle.normal,
                    ),

                    textAlign: TextAlign.end,
                    textScaleFactor: 1.0,
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child:
          Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              // height: isSmallScreen
              //     ? Get.height / 28 * 22.5
              //     : Get.height / 30 * 22.5,
              height: containerHeight,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 5, right: 5),
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(color: isSmallPage() ? Colors.transparent : Colors.black, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Stack(
                children: [
                  Visibility(
                    visible: isSmallPage(),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/fatiha_bg.png',
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Positioned(
                          left: Get.width / 3,
                          right: Get.width / 3,
                          top: containerHeight / 13,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              // 'hello',
                              suraName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Mcs',
                                fontSize: 16,
                                color: normalFontColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(margin: EdgeInsets.only(top: isSmallPage() ? 12 : 0), child: columnWidget(context)),
                ],
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }

  bool isSmallPage() {
    return widget.page == 1 || widget.page == 2;
  }

  String _convertToArabicNumber(int number) {
    if (GetStorage().read(language) != 'ar') {
      return number.toString();
    }
    String res = '';

    final arabicNo = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (var element in number.toString().characters) {
      res += arabicNo[int.parse(element)];
    }

    /*   final latins = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']; */
    return res;
  }

  void getCurrentReciter() async {
    var sharedPef = await SharedPreferences.getInstance();
    var x = sharedPef.getString(reciterKey) ?? "1";

    ReciterModel reciter = await DataBaseHelper.dataBaseInstance().getCurrentReciter(x.toString());
    reciterId = reciter.id!.toString();
  }
}

String? getTagId(WordModel wordModel, Map<int, List> wordTagMap) {
  try {
    int? result = wordTagMap[int.parse(wordModel.word_id!)]?[0];
    if (result == null) {
      return null;
    }
    return result.toString();
  } on Exception catch (e) {
    return null;
  }
}
