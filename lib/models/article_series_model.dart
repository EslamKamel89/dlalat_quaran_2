// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dlalat_quaran_new/models/article_model.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';

class ArticleSeriesModel {
  int? id;
  String? name;
  String? content;
  List<ArticleModel>? articles;

  ArticleSeriesModel({
    this.id,
    this.name,
    this.content,
    this.articles,
  });

  @override
  String toString() {
    return '$name';
    // return 'ArticleSeriesEntity(id: $id, name: $name, content: $content, articles: $articles)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': content,
      'articles': articles?.map((x) => x.toJson()).toList(),
    };
  }

  factory ArticleSeriesModel.fromJson(Map<String, dynamic> json) {
    pr(json, 'ArticleSeriesModel');
    return ArticleSeriesModel(
      id: json['id'] != null ? json['id'] as int : null,
      name: json['name'] != null ? json['name'] as String : null,
      content: json['description'] != null ? json['description'] as String : null,
      articles: json['articles'] == null
          ? []
          : json['articles'].map<ArticleModel>((json) => ArticleModel.fromJson(json)).toList(),
    );
  }
}
