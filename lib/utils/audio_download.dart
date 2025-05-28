import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/page_ayat_sura_model.dart';
import 'package:dlalat_quaran_new/utils/audio_folders.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/player_bottom_widget.dart';

class AudioDownload {
  final CancelToken _cancelToken = CancelToken();
  AudioPlayer? recitersPlayer;
  late String _suraId;
  var isDownloading = false.obs;
  var currentPage = 0;
  String _reciterId = '0';
  bool isPlaying = false;

  set suraId(String value) {
    _suraId = value;
  }

  void clearPlayer() {
    if (recitersPlayer != null) {
      recitersPlayer!.release();
      recitersPlayer = null;
    }
  }

  void downloadPage(int page) async {
    currentPage = page;
    //print(
    //     '_reciter ID  Before $_reciterId Storage Val ${GetStorage().read(reciterKey)} Type is ${GetStorage().read(reciterKey).runtimeType}');
    var preferences = await SharedPreferences.getInstance();
    _reciterId = preferences.getString(reciterKey) ?? "1";
    //print('_reciter ID  $_reciterId');
    List<PageAyatSuraModel> models = await DataBaseHelper.dataBaseInstance().pageAyatSura(page);
    var generateDownloadLink = _generateDownloadLink(models);
    downloadFiles(generateDownloadLink);
  }

  void downloadPageWithoutDialog(int page) async {
    currentPage = page;
    // //print('_reciter ID  Before $_reciterId Storage Val ${GetStorage().read(reciterKey)} Type is ${GetStorage().read(reciterKey).runtimeType}');
    var preferences = await SharedPreferences.getInstance();
    _reciterId = preferences.getString(reciterKey) ?? "1";
    // //print('_reciter ID  $_reciterId');
    List<PageAyatSuraModel> models = await DataBaseHelper.dataBaseInstance().pageAyatSura(page);
    var generateDownloadLink = _generateDownloadLink(models);
    downloadFilesWithoutDialog(generateDownloadLink);
  }

  void downloadFiles(List<String> downloadLinks) async {
    try {
      String reciterPath = await AudioFolders().createReciterFolder(_reciterId.toString());
      print('Reciter Path = $reciterPath ----------------------------- $downloadLinks');
      Dio dio = Dio();

      // if (!Get.isDialogOpen!) {
      //   Get.dialog(DialogLoading());
      // }
      var hasInternet = await isInternetAvailable();
      if (!hasInternet) {
        return;
      }
      isDownloading.value = true;
      controllerObject.setLoading(true);

      for (var i = 0; i < downloadLinks.length; i++) {
        if (!await File('$reciterPath/${downloadLinks[i].split('/').last}').exists()) {
          await dio.download(
            downloadLinks[i],
            '$reciterPath/${downloadLinks[i].split('/').last}',
          );
        }

        // //print('DownLoad Ended ');
      }
      // //print('DownLoad Ended And Exit');
      isDownloading.value = false;
      controllerObject.setLoading(false);
      currentPage++;
      downloadPageWithoutDialog(currentPage);
    } catch (e) {}
  }

  void downloadFilesWithoutDialog(List<String> downloadLinks) async {
    print("reciterPath ------------ $downloadLinks");

    String reciterPath = await AudioFolders().createReciterFolder(_reciterId.toString());
    // //print('Reciter Path = $reciterPath');
    Dio dio = Dio();

    isDownloading.value = true;
    for (var i = 0; i < downloadLinks.length; i++) {
      if (!await File('$reciterPath/${downloadLinks[i].split('/').last}').exists()) {
        await dio.download(
          downloadLinks[i],
          '$reciterPath/${downloadLinks[i].split('/').last}',
          cancelToken: _cancelToken,
        );
      }
      if (!isPlaying) {
        if (i == 0 && recitersPlayer != null) {
          recitersPlayer!.play(DeviceFileSource('$reciterPath/${downloadLinks[i].split('/').last}'));
          recitersPlayer = null;
          isPlaying = true;
        }
      }
      // //print('DownloadFilesWithoutDialog DownLoad Ended ');
    }
    // //print('DownloadFilesWithoutDialog DownLoad Ended And Exit');
    isDownloading.value = false;
  }

  List<String> _generateDownloadLink(List<PageAyatSuraModel> models) {
    List<String> downloadLinks = [];

    for (var x = 0; x < models.length; x++) {
      var model = models[x];
      _suraId = model.suraId;
      var fixedSura = model.suraId.toString().padLeft(3, '0');
      var fixedAyaNo = model.ayaId.toString().padLeft(3, '0');

      String link = '$ayaLink$_reciterId/$_suraId/$fixedSura$fixedAyaNo.mp3';
      downloadLinks.add(link);
    }

    return downloadLinks;
  }

  set reciterId(String value) {
    log('reciterId == $value');
    _reciterId = value;
  }

  Future<bool> isInternetAvailable() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   return true;
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   return true;
    // }
    // return false;
    return true;
  }

  void suraDownload(int suraId, int ayaId, int suraCount) async {
    List<String> downloadLinks = [];
    var preferences = await SharedPreferences.getInstance();
    _reciterId = preferences.getString(reciterKey) ?? "1";
    for (var x = ayaId; x < suraCount; x++) {
      var fixedSura = suraId.toString().padLeft(3, '0');
      var fixedAyaNo = x.toString().padLeft(3, '0');

      String link = '$ayaLink$_reciterId/$suraId/$fixedSura$fixedAyaNo.mp3';
      downloadLinks.add(link);
    }
    print('Sura Downloads $downloadLinks');
    // _cancelToken.cancel();
    downloadFilesWithoutDialog(downloadLinks);
  }

  void suraDownloadPlay(int suraId, int ayaId, int suraCount, AudioPlayer player) async {
    var preferences = await SharedPreferences.getInstance();
    _reciterId = preferences.getString(reciterKey) ?? "1";
    log('reciter Id =>> $_reciterId');

    recitersPlayer = player;
    List<String> downloadLinks = [];
    // _reciterId = GetStorage().read(reciterKey) ?? '1';
    //print('Sura Downloads  Start $downloadLinks Sura suraCount $suraCount');
    for (var x = ayaId; x < suraCount + 1; x++) {
      var fixedSura = suraId.toString().padLeft(3, '0');
      var fixedAyaNo = x.toString().padLeft(3, '0');

      String link = '$ayaLink$_reciterId/$suraId/$fixedSura$fixedAyaNo.mp3';
      downloadLinks.add(link);
      log('audioDownloads $link');
    }
    //print('Sura Downloads $downloadLinks');
    // _cancelToken.cancel();
    downloadFilesWithoutDialog(downloadLinks);
  }
}
