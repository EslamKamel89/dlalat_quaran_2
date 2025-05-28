class RelatedTagModel {
  RelatedTagModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.tagId,
    this.relatedTagId,
  });

  RelatedTagModel.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    tagId = json['tag_id'];
    relatedTagId = json['related_tag_id'];
  }
  int? id;
  String? createdAt;
  String? updatedAt;
  int? tagId;
  int? relatedTagId;
  RelatedTagModel copyWith({
    int? id,
    String? createdAt,
    String? updatedAt,
    int? tagId,
    int? relatedTagId,
  }) =>
      RelatedTagModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        tagId: tagId ?? this.tagId,
        relatedTagId: relatedTagId ?? this.relatedTagId,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['tag_id'] = tagId;
    map['related_tag_id'] = relatedTagId;
    return map;
  }
}
