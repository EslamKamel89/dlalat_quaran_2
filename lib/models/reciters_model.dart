import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:get_storage/get_storage.dart';

class ReciterModel {
  int? id, enabled;
  String? name_ar, name_en, name_fr, name_it, name_es;

  ReciterModel(
      {this.id,
      this.enabled,
      this.name_ar,
      this.name_en,
      this.name_fr,
      this.name_it,
      this.name_es});

  factory ReciterModel.fromJson(Map<String, dynamic> json) => ReciterModel(
        id: json["id"],
        name_ar: json["name_ar"],
        name_en: json["name_en"],
        name_fr: json["name_fr"],
        name_es: json["name_es"],
        name_it: json["name_it"],
        enabled: json["enabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_ar": name_ar,
        "name_en": name_en,
        "name_fr": name_fr,
        "name_es": name_es,
        "name_it": name_it,
        "enabled": enabled,
      };

  @override
  String toString() {
    return name() == 'null'.toUpperCase() ? "" : name();
  }

  String name() {
    String name = name_ar!;
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
        name = name_es!;
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
