import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectLanguageController extends GetxController {
  var selectLanguageId = 0.obs;
  String langCode = 'ar';

  void setLocal(int langId) {
    Locale locale;
    switch (langId) {
      case 6:
        langCode = 'ar';
        locale = const Locale('ar');
        break;
      case 7:
        langCode = 'en';
        locale = const Locale('en');
        break;
      case 13:
        langCode = 'fr';
        locale = const Locale('fr');
        break;
      case 16:
        langCode = 'es';
        locale = const Locale('es');
        break;
      case 21:
        langCode = 'it';
        locale = const Locale('it');
        break;
      default:
        langCode = 'ar';
        locale = const Locale('ar');
    }

    Get.updateLocale(locale);
    selectLanguageId.value = langId;
    update();
  }
}
