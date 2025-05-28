import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SuraModel {
  // late int id;
  // late String name;

  SuraModel(
      {this.id,
      this.sura_ar,
      this.sura_en,
      this.sura_fr,
      this.sura_sp,
      this.sura_it,
      this.page,
      this.location,
      this.sajda,
      this.ayah,
      this.created_at,
      this.updated_at});

  @override
  String toString() {
    return id == 0 ? name() : '${_convertToArabicNumber(id!)} - ${name()} ';
  }

  String _convertToArabicNumber(int number) {
    if (GetStorage().read(language) != 'ar') {
      return number.toString();
    }

    String res = '';

    final arabicNo = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (var element in number.toString().characters) {
      res += arabicNo[int.parse(element)];
    }

/*   final latins = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']; */
    return res;
  }

  int? id;
  String? sura_ar;
  String? sura_en;
  String? sura_fr;
  String? sura_it;
  String? sura_sp;
  int? page;
  int? location;
  int? sajda;
  int? ayah;
  String? created_at;
  String? updated_at;

  factory SuraModel.fromJson(Map<String, dynamic> json) => SuraModel(
      id: json["id"],
      sura_ar: json["sura_ar"].toString(),
      sura_en: json["sura_en"].toString(),
      sura_fr: json["sura_fr"].toString(),
      sura_sp: json["sura_sp"].toString(),
      sura_it: json["sura_it"].toString(),
      location: json["location"],
      page: json["page"],
      sajda: int.parse(json["sajda"].toString()),
      ayah: int.parse(json["ayah"].toString()),
      created_at: json["created_at"].toString(),
      updated_at: json["updated_at"].toString());

  Map<String, dynamic> toJson() => {
        "id": id,
        "sura_ar": sura_ar,
        "sura_en": sura_en,
        "sura_fr": sura_fr,
        "sura_sp": sura_sp,
        "sura_it": sura_it,
        "location": location,
        "page": page,
        "sajda": sajda,
        "ayah": ayah,
        "created_at": created_at,
        "updated_at": updated_at,
      };

  String name() {
    String name = 'ar';
    switch (GetStorage().read(language)) {
      case 'ar':
        name = sura_ar!;
        break;
      case 'en':
        name = ' $sura_en - $sura_ar';
        break;
      case 'fr':
        name =
            ' ${sura_fr.toString().toUpperCase() == 'NULL' ? "" : " $sura_fr -"}  $sura_ar';
        break;
      case 'es':
        name =
            ' ${sura_fr.toString().toUpperCase() == 'NULL' ? "" : " $sura_sp -"} $sura_ar';

        break;
      case 'it':
        name =
            ' ${sura_fr.toString().toUpperCase() == 'NULL' ? "" : " $sura_sp -"} $sura_ar';

        break;
      default:
    }
    return name;
  }
}
