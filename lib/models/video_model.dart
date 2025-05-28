class VideoModel {
  int? id;
  String? url;
  String? name;
  String? type;
  String? word_id;
  int? ayat_id;
  int? enabled;
  String? created_at;
  String? updated_at;

  VideoModel(
      {this.id,
      this.url,
      this.name,
      this.type,
      this.word_id,
      this.ayat_id,
      this.enabled,
      this.created_at,
      this.updated_at});

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
      id: json["id"],
      url: json["url"],
      name: json["name"].toString(),
      type: json["type"].toString(),
      word_id: json["word_id"].toString(),
      // ayat_id: json["ayat_id"],
      enabled: json["enabled"],
      created_at: json["created_at"],
      updated_at: json["updated_at"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "name": name,
        "type": type,
        "word_id": word_id,
        "ayat_id": ayat_id,
        "enabled": enabled,
        "created_at": created_at,
        "updated_at": updated_at,
      };

  @override
  String toString() {
    return name!;
  }
}
