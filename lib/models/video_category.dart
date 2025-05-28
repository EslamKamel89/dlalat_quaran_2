import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../utils/constants.dart';

VideoCategory videoCategoryFromJson(String str) =>
    VideoCategory.fromJson(json.decode(str));
String videoCategoryToJson(VideoCategory data) => json.encode(data.toJson());

class VideoCategory {
  VideoCategory({
    this.id,
    this.icon,
    this.nameAr,
    this.nameEn,
    this.nameFr,
    this.nameSp,
    this.enabled,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.nameIt,
    this.iconUrl,
  });

  VideoCategory.fromJson(dynamic json) {
    id = json['id'].toString();
    icon = json['icon'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    nameFr = json['name_fr'];
    nameSp = json['name_sp'];
    enabled = json['enabled'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    nameIt = json['name_it'];
    iconUrl = json['icon_url'];
  }
  String? id;
  String? icon;
  String? nameAr;
  String? nameEn;
  String? nameFr;
  String? nameSp;
  int? enabled;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? nameIt;
  String? iconUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['icon'] = icon;
    map['name_ar'] = nameAr;
    map['name_en'] = nameEn;
    map['name_fr'] = nameFr;
    map['name_sp'] = nameSp;
    map['enabled'] = enabled;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['name_it'] = nameIt;
    map['icon_url'] = iconUrl;
    return map;
  }

  @override
  String toString() {
    var lang = GetStorage().read(language).toString();
    var name;
    if (lang == 'ar') name = nameAr;
    if (lang == 'en') name = nameEn;
    if (lang == 'fr') name = nameFr;
    if (lang == 'es') name = nameSp;
    return name;
  }
}
