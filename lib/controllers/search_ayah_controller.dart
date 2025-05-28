import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/aya_model.dart';
import 'package:dlalat_quaran_new/models/db_word_model.dart';
import 'package:dlalat_quaran_new/models/sura_model.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:get/get.dart';

abstract class SearchAyahData {
  static List<SuraModel> suras = [];
  static List<AyaModel> ayas = [];
  static List<int?> wordsId = [];
}

class SearchAyahController extends GetxController {
  SuraModel? selectedSuraModel;
  AyaModel? selectedAyaModel;

  updateSelectedSura(SuraModel suraModel) {
    selectedSuraModel = suraModel;
    SearchAyahData.ayas = [];
    DataBaseHelper.dataBaseInstance()
        .getAyaBySuaId(selectedSuraModel?.id ?? 0)
        .then((value) => SearchAyahData.ayas = value);
    update();
  }

  updateSelectedAya(AyaModel ayaModel) {
    selectedAyaModel = ayaModel;
    update();
  }

  clearData() {
    selectedSuraModel = null;
    selectedAyaModel = null;
    SearchAyahData.suras = [];
    SearchAyahData.ayas = [];
    update();
    // pr('IAMHERE');
  }

  Future getWordsIdsByAyahId(int suraId, int ayahId) async {
    const t = 'getWordsIdsByAyahId - SearchAyaController';
    SearchAyahData.wordsId = [];
    List<DbWordModel> wordModels = await DataBaseHelper.dataBaseInstance().getWordByAyahId(suraId, ayahId);
    List<int?> words = wordModels.map((word) => word.id).toList();
    SearchAyahData.wordsId = words.where((id) => id != null).toList();
    // SearchAyahData.wordsId = [77, 78];
    pr(SearchAyahData.wordsId, t);
    update();
  }

  @override
  void onClose() {
    selectedSuraModel = null;
    selectedAyaModel = null;
    SearchAyahData.suras = [];
    SearchAyahData.ayas = [];
    SearchAyahData.wordsId = [];
    update();
    super.onClose();
  }
}
