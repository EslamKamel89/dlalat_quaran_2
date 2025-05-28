import 'dart:developer';

import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:get/get.dart';

class ExplainDialogController extends GetxController {
  var explain = ''.obs;
  var ayaText = ''.obs;
  var videoUrl = 'null'.obs;

  void getAyaExplain(String aya) async {
    var explanation =
        await DataBaseHelper.dataBaseInstance().getExplanation(aya);
    explain.value = explanation['explainText'].toString() == "NULL"
        ? 'not_available'.tr
        : explanation['explainText'].toString();
    ayaText.value = explanation['ayaText'].toString();
    if (explanation['videoUrl'].toString().startsWith('http')) {
      videoUrl.value = explanation['videoUrl'].toString();
    }
    // videoUrl.value = explanation['videoUrl'].toString();
    log('Controller Video Url => ${videoUrl.value}');
    // videoUrl.value = videoModel ?? VideoModel() ;

    update();
  }
}
