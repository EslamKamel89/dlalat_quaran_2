import 'package:dlalat_quaran_new/utils/print_helper.dart';

class TagWordModel {
  TagWordModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.tagId,
    this.wordId,
    this.suraId,
    this.ayahId,
    this.enabled,
  });

  TagWordModel.fromJsonSimplified(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    tagId = json['tag_id'];
    wordId = json['word_id'];
    // suraId = pr(json['sura_id'], 'exception');
    // ayahId = json['ayah_id'];
    // enabled = json['enabled'];
  }

  TagWordModel.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    tagId = json['tag_id'];
    wordId = json['word_id'];
    suraId = pr(json['sura_id'], 'exception');
    ayahId = json['ayah_id'];
    enabled = json['enabled'];
  }
  int? id;
  String? createdAt;
  String? updatedAt;
  int? tagId;
  int? wordId;
  int? suraId;
  int? ayahId;
  int? enabled;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['tag_id'] = tagId;
    map['word_id'] = wordId;
    map['sura_id'] = suraId;
    map['ayah_id'] = ayahId;
    map['enabled'] = enabled;
    return map;
  }

  @override
  String toString() {
    return 'TagWordMode: {tagId:$tagId , wordId:$wordId}';
  }
}
