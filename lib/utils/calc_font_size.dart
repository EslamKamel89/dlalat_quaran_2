import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

double calcFontSize(double size, {isSmall = false}) {
  if (isSmall) return Get.width < 600 ? size : (size.sp * 0.6);
  return Get.width < 600 ? size : (size.sp * 0.9);
}
