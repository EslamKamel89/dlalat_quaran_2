import 'dart:convert';

SuraSearchResultModel suraSearchResultModelFromJson(String str) =>
    SuraSearchResultModel.fromJson(json.decode(str));
String suraSearchResultModelToJson(SuraSearchResultModel data) =>
    json.encode(data.toJson());

class SuraSearchResultModel {
  SuraSearchResultModel({
    this.textAr,
    this.simple,
    this.suraAr,
    this.page,
    this.ayaId,
    this.searchKey,
  });

  SuraSearchResultModel.fromJson(dynamic json) {
    textAr = json['text_ar'];
    simple = json['simple'];
    suraAr = json['sura_ar'];
    page = json['page'];
    searchKey = json['searchKey'];
  }
  String? textAr;
  String? simple;
  String? suraAr;
  String? searchKey;
  int? page;
  int? ayaId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text_ar'] = textAr;
    map['simple'] = simple;
    map['sura_ar'] = suraAr;
    map['page'] = page;
    map['ayaId'] = ayaId;
    map['searchKey'] = searchKey;
    return map;
  }
}
