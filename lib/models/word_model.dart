import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class WordModel {
  WordModel({this.word_id, this.ayaId, this.word_ar});
  String? word_id;
  String? word_ar;
  String? word_en;
  Color? color;
  int? ayaNo;
  int? page;
  String? sura;
  String? suraName;
  String? text_indopak;
  String? ayaId;
  String? juz;
  String? char_type;
  String? verse_key;
  Color? selectedAyaColor;
  int? line;
  int? position;
  String? tagId;
  String? videoId;
  String? wordVideo;

  bool lastAya() {
    var split = verse_key!.split(':');
    return int.parse(split[split.length]) == ayaNo!;
  }

  bool firstAya() {
    return ayaNo == 1 && position == 1;
  }

  @override
  String toString() {
    return '${GetStorage().read(language) == 'ar' ? word_ar : word_en}, ayaId: $ayaId , word_id: $word_id';
  }

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      ayaId: json['ayaId']?.toString(),
      word_id: json['word_id']?.toString(),
      word_ar: json['word_ar']?.toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ayaId': ayaId,
      'word_id': word_id,
      'word_ar': word_ar,
    };
  }
}
