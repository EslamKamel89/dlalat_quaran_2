import 'package:dlalat_quaran_new/models/competition_model.dart';
import 'package:dlalat_quaran_new/ui/join_competition_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompetitionsWidget extends StatefulWidget {
  final CompetitionModel competitionModel;

  const CompetitionsWidget(this.competitionModel, {super.key});

  @override
  State<CompetitionsWidget> createState() => _CompetitionsWidgetState();
}

class _CompetitionsWidgetState extends State<CompetitionsWidget> {
  // String _parseHtmlString(String htmlString) {
  int? maxLines = 1;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.transparent, height: 170, width: double.infinity),
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 30),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            shadowColor: Colors.grey,
            elevation: 10,
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.competitionModel.nameAr ?? '',
                      overflow: maxLines == null ? null : TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontFamily: 'Almarai',
                      ),
                      maxLines: maxLines,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        maxLines != null
                            ? const SizedBox()
                            : TextButton(
                                onPressed: () {
                                  Get.toNamed(
                                    JoinCompetitonView.id,
                                    arguments: {'competitionModel': widget.competitionModel},
                                  );
                                },
                                child: const Text('أجب علي هذا السؤال')),
                        TextButton(
                          onPressed: () {
                            if (maxLines == 1) {
                              maxLines = null;
                              setState(() {});
                              return;
                            }
                            if (maxLines == null) {
                              maxLines = 1;
                              setState(() {});
                              return;
                            }
                          },
                          child: Text(
                            maxLines == null ? 'أخفاء' : 'قراءة المزيد',
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
        // Positioned.directional(
        //   start: 10,
        //   bottom: -10,
        //   textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        //   child: Container(
        //     padding: const EdgeInsets.only(bottom: 25, top: 0, left: 10, right: 10),
        //     decoration: BoxDecoration(
        //       color: primaryColor.withOpacity(0.8),
        //       shape: BoxShape.circle,
        //       border: Border.all(),
        //     ),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Image.asset(
        //           "assets/images/prize1.png",
        //           // "",
        //           width: 50,
        //           height: 50,
        //           fit: BoxFit.cover,
        //         ),
        //         const Text('AED 200', style: TextStyle(color: Colors.white, fontSize: 12)),
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}
