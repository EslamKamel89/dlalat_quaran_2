import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'constants.dart';

class AudioFolders {
  static final AudioFolders _singleton = AudioFolders._internal();
  Dio? _imagesDio;

  factory AudioFolders() {
    return _singleton;
  }

  AudioFolders._internal();

  Future<String> generatePath(
      String? reciter, String? suraId, String ayaNo) async {
    var preferences = await SharedPreferences.getInstance();
    reciter = reciter ?? preferences.getString(reciterKey) ?? "1";
    suraId = suraId ?? suraId!;
    var fixedSura = suraId.padLeft(3, '0');
    var fixedAyaNo = ayaNo.padLeft(3, '0');
    String fullPath =
        '${await AudioFolders().createReciterFolder(reciter)}$fixedSura$fixedAyaNo.mp3';
    return fullPath;
  }

  void checkStoragePermission() async {
    var storagePermission = await Permission.manageExternalStorage.status;
    if (storagePermission.isGranted) {
      await createMainFolder();
    } else {
      await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();
    }
  }

  Future<String> createMainFolder() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    final Directory appDocDirFolder =
        Directory('${appDocDir.path}/dlalatAudio/');
    if (await appDocDirFolder.exists()) {
      //if folder already exists return path
      return appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      GetStorage().write(audioPath, appDocDirFolder.path);
      return appDocDirNewFolder.path;
    }
  }

  Future<String> createIconsFolder() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    final Directory appDocDirFolder = Directory('${appDocDir.path}/icons/');
    if (await appDocDirFolder.exists()) {
      //if folder already exists return path
      return appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      GetStorage().write(iconsPath, appDocDirFolder.path);
      return appDocDirNewFolder.path;
    }
  }

  Future downloadIcon(String iconUrl) async {
    _imagesDio = Dio();
    String iconsFolder = await createIconsFolder();
    log('ISDSD $iconUrl');
    try {
      await _imagesDio!
          .download(iconUrl, '$iconsFolder/${iconUrl.split('/').last}');
    } catch (error) {
      print("error ------------- $error");
    }
  }

  Future<String> createReciterFolder(String reciterId) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    final Directory appDocDirFolder =
        Directory('${appDocDir.path}/dlalatAudio/$reciterId/');
    if (await appDocDirFolder.exists()) {
      //if folder already exists return path
      return appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      GetStorage().write(audioPath, appDocDirFolder.path);
      return appDocDirNewFolder.path;
    }
  }
}
