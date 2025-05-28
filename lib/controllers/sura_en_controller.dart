import 'dart:developer';

import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/word_model.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../utils/colors.dart';

class SuraEnController extends GetxController {
  late DataBaseHelper _dataBaseHelper;
  var suraAyat = <List<WordModel>>[].obs;
  var suraId = 0;
  var suraAyatCount = 0;
  int firstAya = 1;
  var ayaId = 0.obs;
  var fetchingData = false.obs;
  AutoScrollController? scrollController;

  Color? normalFontColor;
  Color? tagWordsColor;
  Color? readWordsColor;
  Color? bgColor;

  TextStyle? redStyle;
  TextStyle? normal;
  TextStyle? playingStyle;

  TextStyle? redStyleEn;
  TextStyle? normalEn;
  TextStyle? playingStyleEn;

  void getSuraAyat() async {
    // log('getSuraAyat Start Method');
    fetchingData.value = true;

    update();
    if (firstAya == 1) {
      // log('page = 1');
      suraAyat.value.clear();
      update();
    }
    var list = await _dataBaseHelper.getFullByAya(suraId, firstAya);
    suraAyat.addAll(list);
    fetchingData.value = false;
    update();
  }

  addItems() {
    if (scrollController != null) {
      scrollController!.addListener(() {
        log("scroll COntroller Listener ");
        if (scrollController!.position.maxScrollExtent ==
            scrollController!.position.pixels) {
          if (firstAya + 11 < suraAyatCount) {
            firstAya = firstAya + 11;
            getSuraAyat();
          }
        }
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    // log('on Init controller');
    _getColors();
    _dataBaseHelper = DataBaseHelper.dataBaseInstance();
  }

  void _getColors() async {
    // if (normalFontColor == null) {
    normalFontColor = colors[
        await DataBaseHelper.dataBaseInstance().getColor(KnormalFontColor)];
    tagWordsColor = colors[
        await DataBaseHelper.dataBaseInstance().getColor(KtagWordsColor)];
    readWordsColor = colors[
        await DataBaseHelper.dataBaseInstance().getColor(KreadWordsColor)];
    bgColor = colors[await DataBaseHelper.dataBaseInstance().getColor(KpageBg)];

    redStyle = TextStyle(color: tagWordsColor, fontFamily: 'Mcs', fontSize: 20);
    normal = TextStyle(color: normalFontColor, fontFamily: 'Mcs', fontSize: 20);
    playingStyle = TextStyle(
      color: readWordsColor,
      fontFamily: 'Mcs',
      fontSize: 20,
    );

    redStyleEn = TextStyle(color: tagWordsColor, fontSize: 20);
    normalEn = TextStyle(color: normalFontColor, fontSize: 20);
    playingStyleEn = TextStyle(color: readWordsColor, fontSize: 20);

    // }
  }
}
