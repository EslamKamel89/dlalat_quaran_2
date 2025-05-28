import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:dlalat_quaran_new/controllers/word_tag_controller.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

enum ReaderName {
  ahmedajamy,
  alafasy,
  hudhaify,
  husary,
  husarymujawwad,
  mahermuaiqly,
  shaatree,
  //
  abdulbasitmurattal,
  abdullahbasfar,
  abdulsamad,
  abdurrahmaansudais,
  aymanswoaid,
  hanirifai,
  minshawimujawwad,
  saoodshuraym,
  ;

  @override
  String toString() {
    switch (this) {
      case ReaderName.ahmedajamy:
        return 'ahmedajamy';
      case ReaderName.alafasy:
        return 'alafasy';
      case ReaderName.hudhaify:
        return 'hudhaify';
      case ReaderName.husary:
        return 'husary';
      case ReaderName.husarymujawwad:
        return 'husarymujawwad';
      case ReaderName.mahermuaiqly:
        return 'mahermuaiqly';
      case ReaderName.shaatree:
        return 'shaatree';
      case ReaderName.abdulbasitmurattal:
        return 'abdulbasitmurattal';
      case ReaderName.abdullahbasfar:
        return 'abdullahbasfar';
      case ReaderName.abdulsamad:
        return 'abdulsamad';
      case ReaderName.abdurrahmaansudais:
        return 'abdurrahmaansudais';
      case ReaderName.aymanswoaid:
        return 'aymanswoaid';
      case ReaderName.hanirifai:
        return 'hanirifai';
      case ReaderName.minshawimujawwad:
        return 'minshawimujawwad';
      case ReaderName.saoodshuraym:
        return 'saoodshuraym';
    }
  }

  String displayName() {
    String languageCode = Get.locale?.languageCode ?? 'ar';
    bool isArabic = languageCode == 'ar';
    switch (this) {
      case ReaderName.ahmedajamy:
        return isArabic ? 'أحمد بن علي العجمي' : 'Ahmad bin Ali Al-Ajmi';
      case ReaderName.alafasy:
        return isArabic ? 'مشاري راشد العفاسي' : 'Mishary Rashid Alafasy';
      case ReaderName.hudhaify:
        return isArabic ? 'علي بن عبد الرحمن الحذيفي' : 'Ali ibn Abdur-Rahman al Hudhaify';
      case ReaderName.husary:
        return isArabic ? 'محمود خليل الحصري' : 'Mahmoud Khalil Al-Hussary';
      case ReaderName.husarymujawwad:
        return isArabic ? 'الحصري مجود' : 'Hussary Mujawwad';
      case ReaderName.mahermuaiqly:
        return isArabic ? 'ماهر المعيقلي' : 'Maher Al-Mu\'aiqly';
      case ReaderName.shaatree:
        return isArabic ? 'أبو بكر الشاطري' : 'Abu Bakr al-Shatri';
      case ReaderName.abdulbasitmurattal:
        return isArabic ? 'عبد الباسط عبد الصمد مرتل' : 'Abdul Basit Abdul Samad Murattal';
      case ReaderName.abdullahbasfar:
        return isArabic ? 'عبد الله بصفر' : 'Abdullah Basfar';
      case ReaderName.abdulsamad:
        return isArabic ? 'عبد الباسط عبد الصم' : 'Abdul Basit Abdul Samad';
      case ReaderName.abdurrahmaansudais:
        return isArabic ? 'عبد الرحمن بن عبد العزيز السديس' : 'Abdur Rahman Ibn Abdul Aziz As-Sudais';
      case ReaderName.aymanswoaid:
        return isArabic ? 'أيمن رشدي سويد' : 'Ayman Rushdi Sowaid';
      case ReaderName.hanirifai:
        return isArabic ? 'هاني الرفاعي' : 'Hani Ar-Rifai';
      case ReaderName.minshawimujawwad:
        return isArabic ? 'محمد صديق المنشاوي' : 'Muhammad Siddiq Al-Minshawi';
      case ReaderName.saoodshuraym:
        return isArabic ? 'سعود بن إبراهيم الشريم' : 'Saud Ibn Ibrahim Al-Shuraim';
    }
  }
}

class ReadAyaController extends GetxController {
  ReaderName readerName = ReaderName.alafasy;
  final AudioPlayer audioPlayer = AudioPlayer();
  final Dio dio = serviceLocator();
  bool isPlaying = false;
  bool showWidget = false;
  Duration duration = const Duration();
  Duration position = const Duration();
  String ayahAr = '';
  int ayaId = 0;
  ScrollController? scrollController;
  List<ReaderName> readersList = [
    ReaderName.ahmedajamy,
    ReaderName.alafasy,
    ReaderName.hudhaify,
    ReaderName.husary,
    ReaderName.husarymujawwad,
    ReaderName.mahermuaiqly,
    ReaderName.shaatree,
    //
    ReaderName.abdulbasitmurattal,
    ReaderName.abdullahbasfar,
    ReaderName.abdulsamad,
    ReaderName.abdurrahmaansudais,
    ReaderName.aymanswoaid,
    ReaderName.hanirifai,
    ReaderName.minshawimujawwad,
    ReaderName.saoodshuraym,
  ];
  String path(int ayaId, ReaderName reader) {
    return 'https://cdn.islamic.network/quran/audio/64/ar.$reader/$ayaId.mp3';
  }

  Future<void> playAyaById(int ayaId, int suraId) async {
    this.ayaId = ayaId;
    updateWordColor();
    const t = 'playAyaById - ReadAyaController';

    Future.delayed(const Duration(seconds: 1)).then((_) {
      if (scrollController != null) {
        double maxExtent = scrollController?.position.maxScrollExtent ?? 0;
        scrollController?.animateTo(maxExtent, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
      }
    });
    resetAudioPlayer();
    showWidget = true;
    ayahAr = await DataBaseHelper.dataBaseInstance().getAyaTextArByAyaId(ayaId);

    Directory dir = await getTemporaryDirectory();
    dir = await dir.create();
    final filePath = "${dir.path}/audio.mp3";
    String localFilePath;

    try {
      final response = await dio.download(
        path(ayaId, readerName),
        filePath,
      );

      if (response.statusCode == 200) {
        localFilePath = filePath;
        pr('Audio file downloaded successfully: $filePath', t);
        await audioPlayer.play(
          DeviceFileSource(localFilePath),
          // volume: 100,
        );
        isPlaying = true;
        update();
      }
    } catch (e) {
      pr('Error downloading audio file: $e', t);
    }
  }

  void resetAudioPlayer() {
    isPlaying = false;
    showWidget = false;
    duration = const Duration();
    position = const Duration();
    ayahAr = '';
    audioPlayer.stop();
    update();
  }

  void updateWordColor() {
    Get.find<WordTagController>().updateWordColor();
  }
}
