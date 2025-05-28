import 'dart:developer';

import 'package:dlalat_quaran_new/controllers/similar_word_controller.dart';
import 'package:dlalat_quaran_new/models/similar_word_model.dart';
import 'package:dlalat_quaran_new/models/sura_search_result_model.dart';
import 'package:dlalat_quaran_new/ui/short_explanation_index.dart';
import 'package:dlalat_quaran_new/ui/sura_screen.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';

class WordResultItem extends StatelessWidget {
  final List<SuraSearchResultModel> _resultModel;

  const WordResultItem(this._resultModel, {super.key});

  @override
  Widget build(BuildContext context) {
    ayaTest();
    return GestureDetector(
      onTap: () {
        searchResultId.value = _resultModel[0].ayaId!;
        Get.to(const SuraScreen(), arguments: {'page': '${_resultModel[0].page}'});
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AlMaraiText(15, 'رقم الصفحة : ${_resultModel[0].page!}'),
            const SizedBox(
              height: 7,
            ),
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(children: ayaTest(), style: DefaultTextStyle.of(context).style),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> ayaTest() {
    List<TextSpan> widgets = [];
    // var words = _resultModel.simple!.split(' ');
    // var ayats = _resultModel.textAr!.split(' ');

    // log('WordResultItem Words length = ${words.length}');
    // log('WordResultItem Ayat length = ${ayats.length}');

    bool isSimilarFound = false;
    SimilarWordModel? similarWordModel;

    for (var x = 0; x < _resultModel.length; x++) {
      for (SimilarWordModel model in SimilarWordData.equalsList) {
        if (_resultModel[x].searchKey! == model.firstWord || _resultModel[x].searchKey! == model.secondWord) {
          isSimilarFound = true;
          similarWordModel = model;
          break;
        }
      }
      Color colored;
      if (isSimilarFound) {
        if (_resultModel[x].simple!.contains(similarWordModel?.firstWord ?? '') ||
            _resultModel[x].simple!.contains(similarWordModel?.secondWord ?? '')) {
          colored = Colors.red;
        } else {
          colored = Colors.black;
        }
        // colored = _resultModel[x].simple!.contains(similarWordModel?.firstWord ?? '') ? Colors.red : Colors.black;
        // colored = _resultModel[x].simple!.contains(similarWordModel?.secondWord ?? '') ? Colors.red : Colors.black;
      } else {
        colored = _resultModel[x].simple!.contains(_resultModel[x].searchKey!) ? Colors.red : Colors.black;
      }
      log('pagesd sd p${_resultModel[x].page}');
      widgets.add(TextSpan(
          text: HtmlUnescape().convert(_resultModel[x].textAr!),
          style: TextStyle(color: colored, fontSize: 25, fontFamily: 'p${_resultModel[x].page}')));
    }
    return widgets;
  }
}
