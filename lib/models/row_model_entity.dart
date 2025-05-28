import 'dart:convert';

List<RowModel> rowModelFromJson(String str) =>
    List<RowModel>.from(json.decode(str).map((x) => RowModel.fromJson(x)));

String rowModelToJson(List<RowModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RowModel {
  RowModel({
    this.id,
    this.aya,
    this.sura,
    this.position,
    this.verseKey,
    this.text,
    this.simple,
    this.juz,
    this.hezb,
    this.rub,
    this.page,
    this.className,
    this.line,
    this.code,
    this.codeV3,
    this.charType,
    this.audio,
    this.translation,
  });

  String? id;
  String? aya;
  String? sura;
  String? position;
  String? verseKey;
  String? text;
  String? simple;
  String? juz;
  String? hezb;
  String? rub;
  String? page;
  String? className;
  String? line;
  String? code;
  String? codeV3;
  String? charType;
  String? audio;
  String? translation;

  factory RowModel.fromJson(Map<String, dynamic> json) => RowModel(
        id: json["id"],
        aya: json["aya"].toString(),
        sura: json["sura"].toString(),
        position: json["position"].toString(),
        verseKey: json["verse_key"].toString(),
        text: json["text"].toString(),
        simple: json["simple"].toString(),
        juz: json["juz"].toString(),
        hezb: json["hezb"].toString(),
        rub: json["rub"].toString(),
        page: json["page"].toString(),
        className: json["class_name"].toString(),
        line: json["line"].toString(),
        code: json["code"].toString(),
        codeV3: json["code_v3"].toString(),
        charType: json["char_type"].toString(),
        audio: json["audio"].toString(),
        translation: json["translation"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "aya": aya,
        "sura": sura,
        "position": position,
        "verse_key": verseKey,
        "text": text,
        "simple": simple,
        "juz": juz,
        "hezb": hezb,
        "rub": rub,
        "page": page,
        "class_name": className,
        "line": line,
        "code": code,
        "code_v3": codeV3,
        "char_type": charType,
        "audio": audio,
        "translation": translation,
      };
}
