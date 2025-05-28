import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogNoInternet extends StatelessWidget {
  const DialogNoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: Get.width - 70,
          height: 130,
          alignment: Alignment.bottomCenter,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlMaraiText(17, 'تأكد من اتصالك بالانترنت.'),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () => Get.back(), child: AlMaraiText(13, "عودة"))
            ],
          ),
        ),
      ),
    );
  }
}
