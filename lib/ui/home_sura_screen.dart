import 'dart:developer';

import 'package:dlalat_quaran_new/ui/search_by_ayah/search_by_ayah_screen.dart';
import 'package:dlalat_quaran_new/ui/search_screen.dart';
import 'package:dlalat_quaran_new/ui/short_explanation_index.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class HomeSuraScreen extends StatefulWidget {
  const HomeSuraScreen({super.key});
  static var id = '/HomeSuraScreen';

  @override
  State<HomeSuraScreen> createState() => _HomeSuraScreenState();
}

class _HomeSuraScreenState extends State<HomeSuraScreen> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    // _tabController!.addListener(() {
    //   setState(() {
    //     currentIndex = _tabController!.index;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initScreenUtil(context);
    return Scaffold(
      backgroundColor: lightGray,
      appBar: QuranBar('short_explanation'.tr),
      body: Column(
        children: [
          const SizedBox(height: 5),
          TabBar(
            indicatorColor: Colors.transparent,
            tabs: [
              TabButton(title: 'التفسير المختصر', selected: currentIndex == 0),
              TabButton(title: 'بحث بالكلمات', selected: currentIndex == 1),
              TabButton(title: "بحث بالأية", selected: currentIndex == 2),
            ],
            controller: _tabController!,
            onTap: (value) {
              log('New Value = $value');
              currentIndex = value;
              setState(() {});
            },
          ),
          const SizedBox(height: 5),
          Expanded(
            child:
                currentIndex == 0
                    ? ShortExplanationIndex()
                    : currentIndex == 1
                    ? SearchScreen()
                    : const SearchAyahcreen(),
          ),
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  String title;
  bool selected;

  TabButton({super.key, required this.title, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 45,
      decoration: BoxDecoration(
        color: selected ? primaryColor2 : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ArabicText(title, color: selected ? Colors.white : Colors.blueGrey),
      // Text(
      //   title,
      //   style: TextStyle(color: selected ? Colors.white : Colors.blueGrey),
      // ),
    );
  }
}
