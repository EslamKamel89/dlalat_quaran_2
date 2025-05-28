import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/reciters_model.dart';
import 'package:dlalat_quaran_new/ui/player_bottom_widget.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerBottomController extends GetxController {
  var prevAya = '';
  var currentAya = '';
  var nextAya = '';
  int currentAyaId = 0;
  var filePath = '';
  var isPlaying = false.obs;
  var currentReciter = ReciterModel().obs;
  var isLoading = false.obs;

  void setLoading(bool loading) {
    isLoading.value = loading;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentReciter();
  }

  void getCurrentReciter() async {
    var sharedPref = await SharedPreferences.getInstance();
    var x = sharedPref.getString(reciterKey) ?? "1";
    currentReciter.value =
        await DataBaseHelper.dataBaseInstance().getCurrentReciter(x.toString());
    update();
  }

  // void getNextRecitationModel(int sura_id, String ayaNo) async {
  //   print('Next Reciter Model Sura Id $sura_id Aya No $ayaNo');
  //   var hasInternet = await isInternetAvailable();
  //   if (hasInternet) {
  //     var file =
  //         await DefaultCacheManager().downloadFile(ayaUrl(sura_id, ayaNo));
  //     file.printError();
  //     filePath = file.file.path;
  //   } else {
  //     internetSnack();
  //     filePath = '';
  //   }
  //
  //   print('Current Path $filePath');
  // }
  //
  // String ayaUrl(int sura_id, String ayaNo) {
  //   var fixedSura = sura_id.toString().padLeft(3, '0');
  //   var fixedAyaNo = ayaNo.toString().padLeft(3, '0');
  //   currentReciter.value.id =
  //       GetStorage().read('reciterKey').toString() == 'null'
  //           ? 1
  //           : GetStorage().read('reciterKey');
  //   print(
  //       'sura Full Link  = $ayaLink${currentReciter.value.id}/$sura_id/$fixedSura$fixedAyaNo.mp3');
  //   return '$ayaLink${currentReciter.value.id}/$sura_id/$fixedSura$fixedAyaNo.mp3';
  // }

  void internetSnack() {
    Get.snackbar('دلالات القرآن', "تأكد من اتصالك بالانترنت",
            colorText: Colors.white,
            backgroundColor: primaryColor,
            snackPosition: SnackPosition.BOTTOM)
        .show();
  }

  @override
  void onClose() {
    audioPlayer.stop();
    super.onClose();
  }
}
