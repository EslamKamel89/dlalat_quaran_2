// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

SuraSearchModel suraSearchModelFromJson(String str) => SuraSearchModel.fromJson(json.decode(str));
String suraSearchModelToJson(SuraSearchModel data) => json.encode(data.toJson());

class SuraSearchModel {
  SuraSearchModel({
    this.count,
    this.suraId,
    this.suraAr,
    this.suraEn,
    this.searchKey,
  });

  SuraSearchModel.fromJson(dynamic json) {
    count = json['count'];
    suraId = json['sura_id'];
    suraAr = json['sura_ar'];
    suraEn = json['sura_en'];
    searchKey = json['searchKey'];
  }
  int? count;
  int? suraId;
  String? suraAr;
  String? suraEn;
  String? searchKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    map['sura_id'] = suraId;
    map['sura_ar'] = suraAr;
    map['sura_en'] = suraEn;
    map['searchKey'] = searchKey;
    return map;
  }

  @override
  String toString() {
    return 'SuraSearchModel(count: $count, suraId: $suraId, suraAr: $suraAr, suraEn: $suraEn, searchKey: $searchKey)';
  }
}
