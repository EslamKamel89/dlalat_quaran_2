import 'dart:developer';

import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/sura_model.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortExplainIndexController extends GetxController {
  var allSuras = <SuraModel>[].obs;
  var filteredList = [].obs;
  var isLoading = true.obs;
  SuraModel suraModel = SuraModel();
  int mPage = 0;

  void getSuraIndex() async {
    log('suraScreen Func');
    var list = await DataBaseHelper.dataBaseInstance().suraIndex();
    if (mPage != 0) {
      suraModel.page = mPage;
      suraModel.sura_ar = 'اكمال القراءة';
      suraModel.sura_en = 'Continue reading';
      suraModel.id = 0;
      list.insert(0, suraModel);
    }
    allSuras.value = list;
    filteredList.value = list;
    isLoading.value = false;
    update();
  }

  void search(String key) {
    print("0000000000000000000000000000000000 $key");
    filteredList.value = allSuras.value
        .where(((x) => x.toString().toLowerCase().contains(key.toLowerCase())))
        .toList();
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    var sharedIn = await SharedPreferences.getInstance();

    mPage = sharedIn.getInt(savedPage) ?? 0;
    log('shortContrtoller $mPage');
    getSuraIndex();
  }
}
