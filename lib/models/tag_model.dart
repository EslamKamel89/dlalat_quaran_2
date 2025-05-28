import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:get_storage/get_storage.dart';

class TagModel {
  TagModel(
      {this.id,
      this.name_ar,
      this.name_en,
      this.name_fr,
      this.name_sp,
      this.name_it,
      this.desc_ar,
      this.desc_en,
      this.desc_sp,
      this.desc_it,
      this.desc_fr,
      this.created_by,
      this.enabled,
      this.created_at,
      this.updated_at});

  @override
  String toString() {
    return name();
  }

  int? id;
  String? name_ar;
  String? name_en;
  String? name_fr;
  String? name_sp;
  String? name_it;
  String? desc_ar;
  String? desc_en;
  String? desc_sp;
  String? desc_it;
  String? desc_fr;
  String? created_by;
  int? enabled;
  String? created_at;
  String? updated_at;

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
      id: json["id"],
      name_ar: json["name_ar"].toString(),
      name_en: json["name_en"].toString(),
      name_fr: json["name_fr"].toString(),
      name_sp: json["name_sp"].toString(),
      name_it: json["name_it"].toString(),
      desc_ar: json["desc_ar"],
      desc_it: json["desc_it"],
      desc_en: json["desc_en"],
      desc_sp: json["desc_sp"],
      desc_fr: json["desc_fr"],
      created_by: json["created_by"],
      enabled: json["enabled"],
      created_at: json["created_at"].toString(),
      updated_at: json["updated_at"].toString());

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_ar": name_ar,
        "name_en": name_en,
        "name_fr": name_fr,
        "name_sp": name_sp,
        "name_it": name_it,
        "desc_it": desc_it,
        "desc_ar": desc_ar,
        "desc_en": desc_en,
        "desc_sp": desc_sp,
        "desc_fr": desc_fr,
        "created_by": created_by,
        "enabled": enabled,
        "created_at": created_at,
        "updated_at": updated_at,
      };

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

  String description() {
    String desc = 'ar';
    switch (GetStorage().read(language)) {
      case 'ar':
        desc = desc_ar ??= '';
        break;
      case 'en':
        desc = desc_en ??= '';
        break;
      case 'fr':
        desc = desc_fr ??= '';
        break;
      case 'es':
        desc = desc_sp ??= '';
        break;
      case 'it':
        desc = desc_it ??= '';
        break;
      default:
        desc = desc_ar ??= '';
    }
    return desc;
    return DataBaseHelper().parseHtmlString(desc);
  }

  String descriptionWithNoTags() {
    String desc = 'ar';
    switch (GetStorage().read(language)) {
      case 'ar':
        desc = desc_ar ??= '';
        break;
      case 'en':
        desc = desc_en ??= '';
        break;
      case 'fr':
        desc = desc_fr ??= '';
        break;
      case 'es':
        desc = desc_sp ??= '';
        break;
      case 'it':
        desc = desc_it ??= '';
        break;
      default:
        desc = desc_ar ??= '';
    }
    // return desc;
    return DataBaseHelper().parseHtmlString(desc);
  }
}
