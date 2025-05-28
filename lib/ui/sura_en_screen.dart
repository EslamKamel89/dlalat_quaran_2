import 'package:dlalat_quaran_new/controllers/sura_en_controller.dart';
import 'package:dlalat_quaran_new/models/sura_model.dart';
import 'package:dlalat_quaran_new/ui/player_bottom_widget.dart';
import 'package:dlalat_quaran_new/ui/short_explanation_index.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/widgets/aya_en_item.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

final suraEnController = Get.put(SuraEnController());
late AutoScrollController? autoScrollController;
ScrollController? enScrollController;

//ignore: must_be_immutable
class SuraEnScreen extends StatelessWidget {
  late SuraModel suraModel;

  SuraEnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    suraModel = SuraModel.fromJson(Get.arguments);
    suraEnController.onInit();
    suraEnController.suraId = suraModel.id!;
    suraEnController.suraAyatCount = suraModel.ayah!;
    suraEnController.firstAya = 1;
    suraEnController.getSuraAyat();
    playerSuraCount.value = suraModel.ayah!;
    enScrollController = suraEnController.scrollController;
    autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical,
        suggestedRowHeight: 300);
    suraEnController.scrollController = autoScrollController!;
    suraEnController.addItems();

    // initScreenUtil(context);
    return WillPopScope(
      onWillPop: () async {
        await audioPlayer.stop();
        return true;
      },
      child: Scaffold(
        appBar: QuranBar(suraModel.toString()),
        backgroundColor: lightGray2,
        body: Column(
          children: [
            Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    Obx(() => ListView.builder(
                          controller: autoScrollController,
                          itemBuilder: (BuildContext context, int index) {
                            if (suraEnController.suraAyat[index][0].ayaId == selectedAyaId.value) {}

                            return AutoScrollTag(
                              key: ValueKey(index),
                              controller: autoScrollController!,
                              index: index,
                              child: AyaEnItem(
                                ayaModel: suraEnController.suraAyat[index],
                                suraEnController: suraEnController,
                              ),
                            );
                          },
                          itemCount: suraEnController.suraAyat.length,
                        )),
                    Obx(() => Visibility(
                          visible: suraEnController.fetchingData.value,
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: primaryColor,
                          )),
                        ))
                  ],
                )),
            Expanded(
              flex: 1,
              child: Obx(
                () => PlayerBottomWidget(ayaId: int.parse(selectedAyaId.value), ayaNo: int.parse(selectAyaNo.value)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
