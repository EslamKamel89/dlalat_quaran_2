import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showCustomSnackBar({
  required String title,
  required String body,
  bool isSuccess = true,
}) {
  Get.showSnackbar(
    GetSnackBar(
      overlayColor: Colors.white,
      titleText: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Almarai',
        ),
      ),
      messageText: Text(
        body,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Almarai',
        ),
      ),
      icon: Icon(isSuccess ? Icons.check : Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
      backgroundColor: isSuccess ? primaryColor.withOpacity(0.8) : Colors.red.withOpacity(0.8),
    ),
  );
}

showCustomSnackBarNoInternet() {
  showCustomSnackBar(title: 'تحذير', body: 'لا يوجد أتصال بالأنترنت', isSuccess: false);
}

showCustomSnackBarFailure() {
  showCustomSnackBar(title: 'خطأ', body: "نأسف لحدوت خطأ تقني و نرجو المحاولة مرة أخري", isSuccess: false);
}
