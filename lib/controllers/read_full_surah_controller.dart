// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:dlalat_quaran_new/controllers/read_aya_controller.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ReadFullSurahController extends GetxController {
  ReaderName readerName = Get.find<ReadAyaController>().readerName;
  AudioPlayer audioPlayer = AudioPlayer();
  final Dio dio = serviceLocator();
  final t = 'ReadFullSurahController';
  ReadFullSurahController();
  ResponseState responseState = ResponseState.initial;
  List<SuraInfoModel> suraInfoModels = suras.map((sura) => SuraInfoModel.fromJson(sura)).toList();
  SuraInfoModel? selectedSuraModel;

  Duration? playerDuration;
  Duration? playerPosition;
  String ayahAr = '';
  int? ayaId;
  //? this is the value used in the dropdown of the new ayas spinner
  int? selectedAyaValue;
  int suraIndex = 0;
  bool isPlaying = false;
  bool stopPlaying = false;
  PlayerState playerState = PlayerState.stopped;

  String path(int ayaId, ReaderName reader) {
    return 'https://cdn.islamic.network/quran/audio/64/ar.$reader/$ayaId.mp3';
  }

  Future<void> playFullSura() async {
    pr(audioPlayer, '$t - audio player');
    String suraName = selectedSuraModel!.sura_en;
    // _checkAudioPlayerDurationAndPosition();
    getSuraIndex(suraName);
    stopPlaying = false;
    isPlaying = true;
    SuraInfoModel suraInfo = SuraInfoModel.fromJson(suras[suraIndex]);
    SuraInfoModel? nextSuraInfo;
    if (suraIndex != suras.length - 1) {
      nextSuraInfo = SuraInfoModel.fromJson(suras[suraIndex + 1]);
    }
    for (var i = pr(ayaId ?? suraInfo.start, '$t - start index');
        i < pr(nextSuraInfo?.start ?? suraInfo.start + 6, '$t - end index');
        pr(i++, '$t -current index')) {
      try {
        await playAyaById(i);
      } on Exception catch (e) {
        pr('Exception occured $e', t);
        pr('playing the aya again');
        await playAyaById(i);
      }
      await Future.delayed(const Duration(seconds: 1));
      pr(stopPlaying, '$t - stopPlaying');
      while ((playerState == PlayerState.playing || playerState == PlayerState.paused) &&
          !stopPlaying) {
        pr('still in loop the state is $playerState', t);
        pr('still in loop the duration in sec is ${playerDuration?.inSeconds}', t);
        pr('still in loop the position in sec is ${playerPosition?.inSeconds}', t);
        if (playerState == PlayerState.completed || playerState == PlayerState.stopped) {
          pr('going to next ayah the state is $playerState ', t);
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }
      if (stopPlaying) {
        break;
      }
    }
    isPlaying = false;
    stopPlaying = false;
  }

  Future<void> playAyaById(int ayaId) async {
    const t = 'playAyaById - ReadFullSurahController';
    await resetAudioPlayer();
    audioPlayer = AudioPlayer();
    listenersSubscription();

    ayahAr = await DataBaseHelper.dataBaseInstance().getAyaTextArByAyaId(ayaId);

    Directory dir = await getTemporaryDirectory();
    dir = await dir.create();
    final filePath = "${dir.path}/audio.mp3";
    String localFilePath;
    readerName = Get.find<ReadAyaController>().readerName;
    responseState = ResponseState.loading;
    update();
    try {
      final response = await dio.download(path(ayaId, readerName), filePath);
      if (response.statusCode == 200) {
        localFilePath = filePath;
        pr('Audio file downloaded successfully: $filePath', t);
        await audioPlayer.play(
          DeviceFileSource(localFilePath),
          // volume: 100,
        );
        responseState = ResponseState.initial;
        await updateAudioPlayerDuration();
        update();
      }
    } catch (e) {
      responseState = ResponseState.initial;
      update();
      pr('Error downloading audio file: $e', t);
      rethrow;
    }
  }

  Future updateAudioPlayerDuration() async {
    playerDuration = await audioPlayer.getDuration();
    pr(playerDuration, 'player Duration');
  }

  Future<void> resetAudioPlayer() async {
    ayahAr = '';
    ayaId = null;
    isPlaying = false;
    await audioPlayer.stop();
    await audioPlayer.release();
    // await audioPlayer.dispose();
    // refresh();
    update();
  }

  void listenersSubscription() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      playerDuration = d;
      // playerDuration = d;
      update();
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      playerPosition = p;
      // playerPosition = p;
      update();
    });
    audioPlayer.onPlayerComplete.listen((_) {
      resetAudioPlayer();
    });
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      playerState = state;
      update();
    });
  }

  Future<void> clearAllData() async {
    await resetAudioPlayer();
    stopPlaying = true;
    await audioPlayer.dispose();
    refresh();
  }

  void getSuraIndex(String suraName) {
    for (var i = 0; i < suras.length; i++) {
      var sura = suras[i];
      if (sura['sura_en'] == suraName) {
        suraIndex = i;
        break;
      }
    }
  }

  void selectSura(SuraInfoModel suraInfoModel) {
    selectedSuraModel = suraInfoModel;
    getSuraIndex(suraInfoModel.sura_en);
    ayaId = selectedSuraModel!.start;
    update();
  }

  @override
  void onInit() {
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      playerState = state;
      pr(state, '$t - from listener registered in controller init state');
    });
    super.onInit();
  }
}

class SuraInfoModel {
  String sura_en;
  String sura_ar;
  int start;
  SuraInfoModel({required this.sura_en, required this.sura_ar, required this.start});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'sura_en': sura_en, 'sura_ar': sura_ar, 'start': start};
  }

  factory SuraInfoModel.fromJson(Map<String, dynamic> json) {
    return SuraInfoModel(
      sura_en: json['sura_en'] as String,
      sura_ar: json['sura_ar'] as String,
      start: json['start'] as int,
    );
  }

  @override
  String toString() => 'SuraInfoModel(sura_en: $sura_en, sura_ar: $sura_ar, start: $start)';
}

const suras = [
  {"sura_en": "Al-Fatiha", "sura_ar": "الفاتحة", "start": 1},
  {"sura_en": "Al-Baqarah", "sura_ar": "البقرة", "start": 8},
  {"sura_en": "Aal-E-Imran", "sura_ar": "آل عمران", "start": 294},
  {"sura_en": "An-Nisa", "sura_ar": "النساء", "start": 494},
  {"sura_en": "Al-Ma'idah", "sura_ar": "المائدة", "start": 670},
  {"sura_en": "Al-An'am", "sura_ar": "الأنعام", "start": 790},
  {"sura_en": "Al-A'raf", "sura_ar": "الأعراف", "start": 955},
  {"sura_en": "Al-Anfal", "sura_ar": "الأنفال", "start": 1161},
  {"sura_en": "At-Tawbah", "sura_ar": "التوبة", "start": 1236},
  {"sura_en": "Yunus", "sura_ar": "يونس", "start": 1365},
  {"sura_en": "Hud", "sura_ar": "هود", "start": 1474},
  //
  {"sura_en": "Yusuf", "sura_ar": "يوسف", "start": 1597},
  {"sura_en": "Ar-Ra'd", "sura_ar": "الرعد", "start": 1708},
  {"sura_en": "Ibrahim", "sura_ar": "ابراهيم", "start": 1751},
  {"sura_en": "Al-Hijr", "sura_ar": "الحجر", "start": 1803},
  {"sura_en": "An-Nahl", "sura_ar": "النحل", "start": 1902},
  {"sura_en": "Al-Isra", "sura_ar": "الإسراء", "start": 2030},
  {"sura_en": "Al-Kahf", "sura_ar": "الكهف", "start": 2141},
  {"sura_en": "Maryam", "sura_ar": "مريم", "start": 2251},
  {"sura_en": "Ta-Ha", "sura_ar": "طه", "start": 2349},
  {"sura_en": "Al-Anbiya", "sura_ar": "الأنبياء", "start": 2484},
  {"sura_en": "Al-Hajj", "sura_ar": "الحج", "start": 2596},
  //
  {"sura_en": "Al-Mu'minun", "sura_ar": "المؤمنون", "start": 2674},
  {"sura_en": "An-Nur", "sura_ar": "النور", "start": 2792},
  {"sura_en": "Al-Furqan", "sura_ar": "الفرقان", "start": 2856},
  {"sura_en": "Ash-Shu'ara", "sura_ar": "الشعراء", "start": 2933},
  {"sura_en": "An-Naml", "sura_ar": "النمل", "start": 3160},
  {"sura_en": "Al-Qasas", "sura_ar": "القصص", "start": 3253},
  {"sura_en": "Al-Ankabut", "sura_ar": "العنكبوت", "start": 3341},
  {"sura_en": "Ar-Rum", "sura_ar": "الروم", "start": 3410},
  {"sura_en": "Luqman", "sura_ar": "لقمان", "start": 3470},
  {"sura_en": "As-Sajda", "sura_ar": "السجدة", "start": 3504},
  {"sura_en": "Al-Ahzab", "sura_ar": "الأحزاب", "start": 3534},
  //
  {"sura_en": "Saba", "sura_ar": "سبأ", "start": 3607},
  {"sura_en": "Fatir", "sura_ar": "فاطر", "start": 3661},
  {"sura_en": "Ya-Sin", "sura_ar": "يس", "start": 3706},
  {"sura_en": "As-Saffat", "sura_ar": "الصافات", "start": 3789},
  {"sura_en": "Sad", "sura_ar": "ص", "start": 3971},
  {"sura_en": "Az-Zumar", "sura_ar": "الزمر", "start": 4059},
  {"sura_en": "Ghafir", "sura_ar": "غافر", "start": 4134},
  {"sura_en": "Fussilat", "sura_ar": "فصلت", "start": 4219},
  {"sura_en": "Ash-Shura", "sura_ar": "الشورى", "start": 4273},
  {"sura_en": "Az-Zukhruf", "sura_ar": "الزخرف", "start": 4326},
  {"sura_en": "Ad-Dukhan", "sura_ar": "الدخان", "start": 4415},
  //
  {"sura_en": "Al-Jathiya", "sura_ar": "الجاثية", "start": 4474},
  {"sura_en": "Al-Ahqaf", "sura_ar": "الأحقاف", "start": 4511},
  {"sura_en": "Muhammad", "sura_ar": "محمد", "start": 4546},
  {"sura_en": "Al-Fath", "sura_ar": "الفتح", "start": 4584},
  {"sura_en": "Al-Hujurat", "sura_ar": "الحجرات", "start": 4613},
  {"sura_en": "Qaf", "sura_ar": "ق", "start": 4631},
  {"sura_en": "Adh-Dhariyat", "sura_ar": "الذاريات", "start": 4676},
  {"sura_en": "At-Tur", "sura_ar": "الطور", "start": 4736},
  {"sura_en": "An-Najm", "sura_ar": "النجم", "start": 4785},
  {"sura_en": "Al-Qamar", "sura_ar": "القمر", "start": 4847},
  {"sura_en": "Ar-Rahman", "sura_ar": "الرحمن", "start": 4902},
  //
  {"sura_en": "Al-Waqia", "sura_ar": "الواقعة", "start": 4980},
  {"sura_en": "Al-Hadid", "sura_ar": "الحديد", "start": 5076},
  {"sura_en": "Al-Mujadila", "sura_ar": "المجادلة", "start": 5105},
  {"sura_en": "Al-Hashr", "sura_ar": "الحشر", "start": 5127},
  {"sura_en": "Al-Mumtahina", "sura_ar": "الممتحنة", "start": 5151},
  {"sura_en": "As-Saff", "sura_ar": "الصف", "start": 5164},
  {"sura_en": "Al-Jumu'a", "sura_ar": "الجمعة", "start": 5178},
  {"sura_en": "Al-Munafiqun", "sura_ar": "المنافقون", "start": 5189},
  {"sura_en": "At-Taghabun", "sura_ar": "التغابن", "start": 5200},
  {"sura_en": "At-Talaq", "sura_ar": "الطلاق", "start": 5218},
  {"sura_en": "At-Tahrim", "sura_ar": "التحريم", "start": 5230},
  //
  {"sura_en": "Al-Mulk", "sura_ar": "الملك", "start": 5242},
  {"sura_en": "Al-Qalam", "sura_ar": "القلم", "start": 5272},
  {"sura_en": "Al-Haaqqa", "sura_ar": "الحاقة", "start": 5324},
  {"sura_en": "Al-Ma'arij", "sura_ar": "المعارج", "start": 5376},
  {"sura_en": "Nuh", "sura_ar": "نوح", "start": 5420},
  {"sura_en": "Al-Jinn", "sura_ar": "الجن", "start": 5448},
  {"sura_en": "Al-Muzzammil", "sura_ar": "المزمل", "start": 5476},
  {"sura_en": "Al-Muddathir", "sura_ar": "المدثر", "start": 5496},
  {"sura_en": "Al-Qiyama", "sura_ar": "القيامة", "start": 5552},
  {"sura_en": "Al-Insan", "sura_ar": "الإنسان", "start": 5592},
  {"sura_en": "Al-Mursalat", "sura_ar": "المرسلات", "start": 5623},
  //
  {"sura_en": "An-Naba", "sura_ar": "النبأ", "start": 5673},
  {"sura_en": "An-Nazi'at", "sura_ar": "النازعات", "start": 5713},
  {"sura_en": "Abasa", "sura_ar": "عبس", "start": 5759},
  {"sura_en": "At-Takwir", "sura_ar": "التكوير", "start": 5801},
  {"sura_en": "Al-Infitar", "sura_ar": "الانفطار", "start": 5830},
  {"sura_en": "Al-Mutaffifin", "sura_ar": "المطففين", "start": 5849},
  {"sura_en": "Al-Inshiqaq", "sura_ar": "الانشقاق", "start": 5885},
  {"sura_en": "Al-Buruj", "sura_ar": "البروج", "start": 5910},
  {"sura_en": "At-Tariq", "sura_ar": "الطارق", "start": 5932},
  {"sura_en": "Al-A'la", "sura_ar": "الأعلى", "start": 5949},
  {"sura_en": "Al-Ghashiya", "sura_ar": "الغاشية", "start": 5968},
  //
  {"sura_en": "Al-Fajr", "sura_ar": "الفجر", "start": 5994},
  {"sura_en": "Al-Balad", "sura_ar": "البلد", "start": 6024},
  {"sura_en": "Ash-Shams", "sura_ar": "الشمس", "start": 6044},
  {"sura_en": "Al-Lail", "sura_ar": "الليل", "start": 6059},
  {"sura_en": "Ad-Duha", "sura_ar": "الضحى", "start": 6080},
  {"sura_en": "Ash-Sharh", "sura_ar": "الشرح", "start": 6091},
  {"sura_en": "At-Tin", "sura_ar": "التين", "start": 6099},
  {"sura_en": "Al-'Alaq", "sura_ar": "العلق", "start": 6107},
  {"sura_en": "Al-Qadr", "sura_ar": "القدر", "start": 6126},
  {"sura_en": "Al-Bayyina", "sura_ar": "البينة", "start": 6131},
  {"sura_en": "Az-Zalzala", "sura_ar": "الزلزلة", "start": 6139},
  {"sura_en": "Al-Adiyat", "sura_ar": "العاديات", "start": 6147},
  {"sura_en": "Al-Qari'a", "sura_ar": "القارعة", "start": 6158},
  {"sura_en": "At-Takathur", "sura_ar": "التكاثر", "start": 6169},
  //
  {"sura_en": "Al-Asr", "sura_ar": "العصر", "start": 6177},
  {"sura_en": "Al-Humaza", "sura_ar": "الهمزة", "start": 6180},
  {"sura_en": "Al-Fil", "sura_ar": "الفيل", "start": 6189},
  {"sura_en": "Quraysh", "sura_ar": "قريش", "start": 6194},
  {"sura_en": "Al-Ma'un", "sura_ar": "الماعون", "start": 6198},
  {"sura_en": "Al-Kawthar", "sura_ar": "الكوثر", "start": 6205},
  {"sura_en": "Al-Kafirun", "sura_ar": "الكافرون", "start": 6208},
  {"sura_en": "An-Nasr", "sura_ar": "النصر", "start": 6214},
  {"sura_en": "Al-Masad", "sura_ar": "المسد", "start": 6217},
  {"sura_en": "Al-Ikhlas", "sura_ar": "الإخلاص", "start": 6222},
  {"sura_en": "Al-Falaq", "sura_ar": "الفلق", "start": 6226},
  {"sura_en": "An-Nas", "sura_ar": "الناس", "start": 6231},
];
