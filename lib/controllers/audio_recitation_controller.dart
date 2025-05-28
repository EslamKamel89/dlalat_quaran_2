import 'package:audioplayers/audioplayers.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/main.dart';
import 'package:dlalat_quaran_new/models/reciters_model.dart';
import 'package:dlalat_quaran_new/models/sura_model.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioRecitationController extends GetxController {
  var recitersList = <ReciterModel>[].obs;
  var selectedReciter = ReciterModel().obs;
  var showPlayer = false.obs;

  var surasList = <SuraModel>[].obs;
  var selectedSura = SuraModel().obs;

  var ayatList = <String>[].obs;
  var selectAya = '1'.obs;

  var selectedSuraAyatCount = 0.obs;
  var suraId = 0.obs;

  String filePath = '';

  var isPlaying = false.obs;

  AudioPlayer? audioPlayer;
  PlayerState playerState = PlayerState.stopped;

  void playerVisibleState(bool status) {
    showPlayer.value = status;
    update();
  }

  void getReciter() async {
    recitersList.value = await DataBaseHelper.dataBaseInstance().getReciters();
    var sharedPref = await SharedPreferences.getInstance();
    var selectedReciterId = sharedPref.getString(reciterKey) ?? "1";
    try {
      selectedReciter.value = recitersList
          .where(((x) => x.id!.toString() == selectedReciterId))
          .first;
    } catch (e) {
      selectedReciter.value = recitersList[0];
    }

    update();
  }

  void getSuras() async {
    surasList.value = await DataBaseHelper().suraIndex();
    selectedSura.value = surasList[0];
    suraId.value = surasList[0].id!;
    getSuraAyat(surasList[0].id!);
    selectAya.value = '1';
    update();
  }

  void getSuraAyat(int suraId) async {
    selectedSuraAyatCount.value =
        await DataBaseHelper.dataBaseInstance().suraCount(suraId);
    _ayatListFun();
    update();
  }

  void _ayatListFun() {
    List<String> ayat = [];
    for (var x = 0; x < selectedSuraAyatCount.value; x++) {
      ayat.add((x + 1).toString());
    }
    ayatList.value = ayat;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getReciter();
    getSuras();
  }

  @override
  void onClose() {
    super.onClose();
    selectAya.value = '1';
  }
}
