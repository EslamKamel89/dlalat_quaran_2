import 'dart:convert';

AyaModel ayaModelFromJson(String str) => AyaModel.fromJson(json.decode(str));

String ayaModelToJson(AyaModel data) => json.encode(data.toJson());

class AyaModel {
  AyaModel({
    this.id,
    this.suraId,
    this.ayah,
    this.textAr,
    this.simple,
    this.textEn,
    this.textFr,
    this.textSp,
    this.explainAr,
    this.explainEn,
    this.explainFr,
    this.explainSp,
    this.juz,
    this.hezb,
    this.page,
    this.word,
    this.sajde,
    this.sajdeNumber,
    this.rub,
    this.verseKey,
    this.theletter,
    this.sortnozol,
    this.sortalphabet,
    this.meccamedinan,
    this.vedio,
    this.createdBy,
    this.enabled,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? suraId;
  int? ayah;
  String? textAr;
  String? simple;
  String? textEn;
  String? textFr;
  String? textSp;
  String? explainAr;
  String? explainEn;
  String? explainFr;
  String? explainSp;
  int? juz;
  int? hezb;
  int? page;
  String? word;
  int? sajde;
  int? sajdeNumber;
  int? rub;
  String? verseKey;
  int? theletter;
  int? sortnozol;
  int? sortalphabet;
  int? meccamedinan;
  String? vedio;
  int? createdBy;
  int? enabled;
  String? createdAt;
  String? updatedAt;

  factory AyaModel.fromJson(Map<String, dynamic> json) => AyaModel(
        id: json["id"],
        suraId: json["sura_id"],
        ayah: json["ayah"],
        textAr: json["text_ar"],
        simple: json["simple"],
        textEn: json["text_en"],
        textFr: json["text_fr"],
        textSp: json["text_sp"],
        explainAr: json["explain_ar"],
        explainEn: json["explain_en"],
        explainFr: json["explain_fr"],
        explainSp: json["explain_sp"],
        juz: json["juz"],
        hezb: json["hezb"],
        page: json["page"],
        word: json["word"],
        sajde: json["sajde"] == null || json["sajde"] == "NULL" ? 0 : int.parse(json["sajde"]),
        sajdeNumber: json["sajde_number"] == "NULL"
            ? 0
            : json["sajde_number"] is String
                ? 0
                : json["sajde_number"],
        rub: json["rub"],
        verseKey: json["verse_key"],
        theletter: json["theletter"] == "NULL" ? 0 : json["theletter"],
        sortnozol: json["sortnozol"] == "NULL" ? 0 : json["sortnozol"],
        sortalphabet: json["sortalphabet"] == "NULL" ? 0 : json["sortalphabet"],
        meccamedinan: json["meccamedinan"] == "NULL" ? 0 : json["meccamedinan"],
        vedio: json["vedio"],
        // createdBy: json["created_by"]!,
        enabled: json["enabled"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sura_id": suraId,
        "ayah": ayah,
        "text_ar": textAr,
        "simple": simple,
        "text_en": textEn,
        "text_fr": textFr,
        "text_sp": textSp,
        "explain_ar": explainAr,
        "explain_en": explainEn,
        "explain_fr": explainFr,
        "explain_sp": explainSp,
        "juz": juz,
        "hezb": hezb,
        "page": page,
        "word": word,
        "sajde": sajde,
        "sajde_number": sajdeNumber,
        "rub": rub,
        "verse_key": verseKey,
        "theletter": theletter,
        "sortnozol": sortnozol,
        "sortalphabet": sortalphabet,
        "meccamedinan": meccamedinan,
        "vedio": vedio,
        "created_by": createdBy,
        "enabled": enabled,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
  @override
  String toString() {
    return verseKey.toString();
  }
}
