class DbWordModel {
  DbWordModel({
    required this.id,
    required this.position,
    // required this.textIndopak,
    required this.verseKey,
    required this.line,
    required this.page,
    required this.code,
    required this.codeV3,
    required this.className,
    required this.wordAr,
    required this.charType,
    required this.wordEn,
    required this.wordFr,
    required this.wordSp,
    required this.audio,
    required this.ayatId,
    required this.suraId,
    required this.juz,
    required this.hezb,
    required this.rub,
    required this.simple,
    required this.vedio,
    required this.createdAt,
    required this.updatedAt,
    required this.translation,
  });
  late final int? id;
  late final int? position;
  // late final String? textIndopak;
  late final String? verseKey;
  late final int? line;
  late final int? page;
  late final String? code;
  late final String? codeV3;
  late final String? className;
  late final String? wordAr;
  late final String? charType;
  late final String? wordEn;
  late final String? wordFr;
  late final String? wordSp;
  late final String? audio;
  late final int? ayatId;
  late final int? suraId;
  late final int? juz;
  late final int? hezb;
  late final int? rub;
  late final String? simple;
  late final String? vedio;
  late final String? createdAt;
  late final String? updatedAt;
  late final String? translation;

  DbWordModel.fromJsonOnlyAyaId(Map<String, dynamic> json) {
    id = json['id'];
    ayatId = json['ayat_id'];
  }
  Map<String, dynamic> toJsonOnlyAyaId() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['ayat_id'] = ayatId;
    return data;
  }

  DbWordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
    // textIndopak = json['text_indopak'];
    verseKey = json['verse_key'];
    line = json['line'];
    page = json['page'];
    code = json['code'];
    codeV3 = json['code_v3'];
    className = json['class_name'];
    wordAr = json['word_ar'];
    charType = json['char_type'];
    wordEn = json['word_en'];
    wordFr = json['word_fr'];
    wordSp = json['word_sp'];
    audio = json['audio'];
    ayatId = json['ayat_id'];
    suraId = json['sura_id'];
    juz = json['juz'];
    hezb = json['hezb'];
    rub = json['rub'];
    simple = json['simple'];
    vedio = json['vedio'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    translation = json['translation'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['position'] = position;
    // _data['text_indopak'] = textIndopak;
    data['verse_key'] = verseKey;
    data['line'] = line;
    data['page'] = page;
    data['code'] = code;
    data['code_v3'] = codeV3;
    data['class_name'] = className;
    data['word_ar'] = wordAr;
    data['char_type'] = charType;
    data['word_en'] = wordEn;
    data['word_fr'] = wordFr;
    data['word_sp'] = wordSp;
    data['audio'] = audio;
    data['ayat_id'] = ayatId;
    data['sura_id'] = suraId;
    data['juz'] = juz;
    data['hezb'] = hezb;
    data['rub'] = rub;
    data['simple'] = simple;
    data['vedio'] = vedio;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['translation'] = translation;
    return data;
  }
}
