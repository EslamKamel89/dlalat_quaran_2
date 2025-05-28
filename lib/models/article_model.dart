import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';

class ArticleModel {
  int? id;
  int? lang_id;
  String? name;
  String? description;
  String? created_by;
  int? enabled;
  String? created_at;
  String? updated_at;

  ArticleModel(
      {this.id,
      this.lang_id,
      this.name,
      this.description,
      this.created_by,
      this.enabled,
      this.created_at,
      this.updated_at});

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
      id: json["id"],
      lang_id: json["lang_id"],
      name: json["name"].toString(),
      // description: json["description"].toString(),
      description: pr(
          json["description"].toString().replaceAll('quot;', '"').replaceAll('amp;', '').replaceAll('&', ''),
          'test123'),
      created_by: json["created_by"].toString(),
      enabled: json["enabled"],
      created_at: json["created_at"],
      updated_at: json["updated_at"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "lang_id": lang_id,
        "name": name,
        "description": description,
        "created_by": created_by,
        "enabled": enabled,
        "created_at": created_at,
        "updated_at": updated_at,
      };

  @override
  String toString() {
    // TODO: implement toString
    return name!;
  }

  String descriptionWithNoTags() {
    return DataBaseHelper().parseHtmlString(description ?? '');
  }
}
