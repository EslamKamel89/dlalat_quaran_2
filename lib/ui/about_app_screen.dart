import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutAppScreen extends StatelessWidget {
  static String id = '/AboutAppScreen';

  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // initScreenUtil(context);
    return Scaffold(
      backgroundColor: lightGray,
      appBar: QuranBar('about_app'.tr),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                margin: const EdgeInsets.only(top: 20),
                width: Get.width / 3.5,
                height: Get.width / 3.5,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      logoSmall,
                      height: Get.width / 7,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FittedBox(
                        child: Text('app_name'.tr, style: const TextStyle(color: Colors.white, fontFamily: 'Almarai')))
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [BoxShadow(color: mediumGray, blurRadius: 10)]),
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
                child: SingleChildScrollView(
                  child: AlMaraiText(0, randomText),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
