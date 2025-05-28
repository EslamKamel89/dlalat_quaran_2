// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

import 'package:dlalat_quaran_new/models/video_model.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:get_storage/get_storage.dart';

class VideoSeriesModel {
  int? id;
  String? name_ar;
  String? name_en;
  String? name_fr;
  String? name_sp;
  String? name_it;
  List<VideoModel>? videos;
  VideoSeriesModel({
    this.id,
    this.name_ar,
    this.name_en,
    this.name_fr,
    this.name_sp,
    this.name_it,
    this.videos,
  });

  VideoSeriesModel copyWith({
    int? id,
    String? name_ar,
    String? name_en,
    String? name_fr,
    String? name_sp,
    String? name_it,
    List<VideoModel>? videos,
  }) {
    return VideoSeriesModel(
      id: id ?? this.id,
      name_ar: name_ar ?? this.name_ar,
      name_en: name_en ?? this.name_en,
      name_fr: name_fr ?? this.name_fr,
      name_sp: name_sp ?? this.name_sp,
      name_it: name_it ?? this.name_it,
      videos: videos ?? this.videos,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_ar': name_ar,
      'name_en': name_en,
      'name_fr': name_fr,
      'name_sp': name_sp,
      'name_it': name_it,
      'videos': videos?.map((x) => x.toJson()).toList(),
    };
  }

  factory VideoSeriesModel.fromJson(Map<String, dynamic> json) {
    return VideoSeriesModel(
      id: json['id'] != null ? json['id'] as int : null,
      name_ar: json['name_ar'] != null ? json['name_ar'] as String : null,
      name_en: json['name_en'] != null ? json['name_en'] as String : null,
      name_fr: json['name_fr'] != null ? json['name_fr'] as String : null,
      name_sp: json['name_sp'] != null ? json['name_sp'] as String : null,
      name_it: json['name_it'] != null ? json['name_it'] as String : null,
      videos:
          json['videos'] == null ? [] : json['videos'].map<VideoModel>((json) => VideoModel.fromJson(json)).toList(),
    );
  }

  @override
  String toString() {
    return name();
    // return 'VideoSeriesModel(id: $id, name_ar: $name_ar, name_en: $name_en, name_fr: $name_fr, name_sp: $name_sp, name_it: $name_it, videos: $videos)';
  }

  String name() {
    String name = name_ar ?? '';
    switch (GetStorage().read(language)) {
      case 'ar':
        name = name_ar!;
        break;
      case 'en':
        name = name_en!;
        break;
      case 'fr':
        name = name_fr!;
        break;
      case 'es':
        name = name_sp!;
        break;
      case 'it':
        name = name_it!;
        break;
      default:
        name = name_ar!;
    }
    return name;
  }
}
