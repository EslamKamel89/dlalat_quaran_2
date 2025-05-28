import 'dart:developer';

import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/sura_search_result_model.dart';
import 'package:get/get.dart';

class SearchResultController extends GetxController {
  var ayatList = <List<SuraSearchResultModel>>[].obs;

  void getDetails(int suraId, String key) async {
    ayatList.value =
        await DataBaseHelper.dataBaseInstance().getDetails(suraId, key);
    log('Full Sura $ayatList');
    update();
  }
}
