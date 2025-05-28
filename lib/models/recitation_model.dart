import 'dart:convert';

RecitationModel recitationModelFromJson(String str) =>
    RecitationModel.fromJson(json.decode(str));

String recitationModelToJson(RecitationModel data) =>
    json.encode(data.toJson());

class RecitationModel {
  RecitationModel({
    this.status,
    this.current,
    this.prev,
    this.next,
  });

  bool? status;
  String? current;
  String? prev;
  String? next;

  factory RecitationModel.fromJson(Map<String, dynamic> json) =>
      RecitationModel(
        status: json["status"],
        current: json["current"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "current": current,
        "prev": prev,
        "next": next,
      };
}
