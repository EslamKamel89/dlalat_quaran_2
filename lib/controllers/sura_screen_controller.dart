import 'package:dlalat_quaran_new/controllers/short_explanation_index_controller.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:get/get.dart';

class SuraScreenController extends GetxController {
  late DataBaseHelper _dataBaseHelper;
  var currentPage = [].obs;
  var suraName = ''.obs;
  var newPage = 0.obs;
  var juz = "0".obs;

  int ayaNo = 0;

  var canSwipe = true.obs;

  void getPage(int page) async {
    var list = await _dataBaseHelper.getFull(page);
    currentPage.value = list;
    newPage.value = page;

    getSuraName(int.parse(currentPage.value[list.length - 1][0].sura));
    update();

    getJuz(int.parse(currentPage.value[0][0].aya),
        int.parse(currentPage.value[0][0].sura));
  }

  void getJuz(int aya, int sura) async {
    juz.value = await _dataBaseHelper.getJuz(aya, sura);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _dataBaseHelper = DataBaseHelper.dataBaseInstance();
  }

  void getSuraName(int page) async {
    suraName.value = await _dataBaseHelper.getSuraByPage(page);
    update();
  }

  @override
  void onClose() async {
    super.onClose();
    Get.put(ShortExplainIndexController());
    Get.delete<SuraScreenController>();
  }
}
