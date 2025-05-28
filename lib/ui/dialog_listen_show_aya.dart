import 'dart:ui';

import 'package:dlalat_quaran_new/controllers/dialog_word_tag_controller.dart';
import 'package:dlalat_quaran_new/ui/video_player_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/widgets/custom_buttons.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:dlalat_quaran_new/widgets/video_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/expain_dialog_controller.dart';
import '../utils/constants.dart';
import '../widgets/video_item_dialog.dart';
import 'new_single_sura_screen.dart';

class DialogListenShowAya extends StatefulWidget {
  final int x;
  final String ayaText;
  final String ayaNum;
  final String suraText;
  final int j;
  final GlobalKey<NewSingleSuraScreenState>? newSingleSuraScreenState;

  const DialogListenShowAya({
    super.key,
    required this.x,
    required this.j,
    this.newSingleSuraScreenState,
    this.ayaText = "",
    this.ayaNum = "",
    this.suraText = "",
  });

  @override
  State<DialogListenShowAya> createState() => _DialogListenShowAyaState();
}

class _DialogListenShowAyaState extends State<DialogListenShowAya>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(left: 30, right: 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.height *
                    0.7, // Limit the height to 70% of the screen height
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          child:
                              const Icon(Icons.close_sharp, color: Colors.red),
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        widget.ayaText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: (Get.width - 80) / 2,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              widget.newSingleSuraScreenState?.currentState
                                  ?.listenSound(widget.x, widget.j);
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              "listenToAya".tr,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        SizedBox(
                          width: (Get.width - 80) / 2,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              var shareText =
                                  ' ${"Application : ".tr} ${"app_name".tr} \n'
                                  '${widget.ayaText}\n'
                                  '${"aya".tr} ${widget.ayaNum}  ${"from".tr}  ${widget.suraText}\n';
                              Share.share(shareText);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              'shareAya'.tr,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
