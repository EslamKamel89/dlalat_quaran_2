import 'package:dlalat_quaran_new/controllers/select_language_controller.dart';
import 'package:dlalat_quaran_new/models/language_model.dart';
import 'package:dlalat_quaran_new/ui/intro_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/widgets/splash_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SelectLanguageScreen extends StatelessWidget {
  static String id = '/SelectLanguageScreen';

  SelectLanguageScreen({super.key});

  final SelectLanguageController languageController =
      Get.put(SelectLanguageController());

  @override
  Widget build(BuildContext context) {
    var itemSize2 = (MediaQuery.of(context).size.width - 130);
    // languageController.setLocal(7);
    return SafeArea(
      child: SplashBackground(
          childWidget: Column(
        children: [
          SizedBox(
            height: Get.height / 5,
          ),
          Image.asset(
            logoMedium,
            height: Get.height / 8,
          ),
          Container(
            margin: const EdgeInsets.only(top: 3),
            width: itemSize2,
            child: Text(
              'app_name'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Almarai",
                  fontSize: 24,
                  decoration: TextDecoration.none),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
                color: lightGray, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SizedBox(
                  width: Get.width / 1.4,
                  height: Get.height / 3.8,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: GetBuilder<SelectLanguageController>(
                      builder: (controller) => ListView.builder(
                        itemBuilder: (context, index) {
                          return LangWidget(
                              languageController.selectLanguageId.value,
                              modes[index],
                              languageController);
                        },
                        itemCount: modes.length,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: Get.width / 1.5,
                    child: ElevatedButton(
                      onPressed: () {
                        GetStorage()
                            .write(language, languageController.langCode);
                        Get.to(() => const IntroScreen());
                        // languageController.update();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor),
                      child: Text(
                        "start".tr,
                        style: const TextStyle(
                            fontFamily: 'Almarai', color: Colors.white),
                      ),
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }
}

class LangWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final int selectedLang;
  final SelectLanguageController _controller;

  const LangWidget(this.selectedLang, this.languageModel, this._controller,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 2,
        ),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: selectedLang == languageModel.lagId
                ? Colors.white
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12)),
        height: Get.height / 20,
        child: Row(
          children: [
            Image.asset(
              languageModel.langFlag,
              height: 30,
              width: 40,
            ),
            Text(
              languageModel.langName,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                  decoration: TextDecoration.none),
            )
          ],
        ),
      ),
      onTap: () {
        _controller.setLocal(languageModel.dbLangId);
      },
    );
  }
}
