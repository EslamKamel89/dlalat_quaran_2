/// id : "INTEGER"
/// created_at : "TEXT"
/// updated_at : "TEXT"
/// article_id : "INTEGER"
/// related_article_id : "INTEGER"

class RelatedArticlesModel {
  RelatedArticlesModel({
    int? id,
    String? createdAt,
    String? updatedAt,
    int? articleId,
    int? relatedArticleId,
  }) {
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _articleId = articleId;
    _relatedArticleId = relatedArticleId;
  }

  RelatedArticlesModel.fromJson(dynamic json) {
    _id = json['id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _articleId = json['article_id'];
    _relatedArticleId = json['related_article_id'];
  }
  int? _id;
  String? _createdAt;
  String? _updatedAt;
  int? _articleId;
  int? _relatedArticleId;
  RelatedArticlesModel copyWith({
    int? id,
    String? createdAt,
    String? updatedAt,
    int? articleId,
    int? relatedArticleId,
  }) =>
      RelatedArticlesModel(
        id: id ?? _id,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        articleId: articleId ?? _articleId,
        relatedArticleId: relatedArticleId ?? _relatedArticleId,
      );
  int? get id => _id;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get articleId => _articleId;
  int? get relatedArticleId => _relatedArticleId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['article_id'] = _articleId;
    map['related_article_id'] = _relatedArticleId;
    return map;
  }
}
