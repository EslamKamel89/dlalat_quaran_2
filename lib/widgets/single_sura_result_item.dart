import 'package:dlalat_quaran_new/models/sura_search_model.dart';
import 'package:dlalat_quaran_new/ui/search_result_screen.dart';
import 'package:dlalat_quaran_new/utils/juz_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleSuraResultItem extends StatelessWidget {
  final SuraSearchModel suraModel;

  const SingleSuraResultItem(this.suraModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        onPressed: () => Get.to(SearchResultScreen(),
            transition: Transition.fade, arguments: suraModel.toJson()),
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 50,
          child: Row(
            children: [
              Expanded(
                  child: Text(
                '${arabicNumber(suraModel.suraId!)} - ${suraModel.suraAr!}',
                style: const TextStyle(fontFamily: "Almarai", fontSize: 20),
              )),
              SizedBox(
                width: 70,
                child: Text('عدد : ${arabicNumber(suraModel.count!)}'),
              ),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}
