import 'package:dlalat_quaran_new/controllers/correct_word_controller.dart';
import 'package:dlalat_quaran_new/controllers/read_aya_controller.dart';
import 'package:dlalat_quaran_new/controllers/search_ayah_controller.dart';
import 'package:dlalat_quaran_new/models/word_model.dart';
import 'package:dlalat_quaran_new/ui/new_single_sura_screen.dart';
import 'package:dlalat_quaran_new/ui/short_explanation_index.dart';
import 'package:dlalat_quaran_new/utils/calc_font_size.dart';
import 'package:dlalat_quaran_new/utils/hex_to_int.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';

// List<WordModel> replaceWords = [
//   WordModel(
//     ayaId: '989',
//     word_id: '22150',
//     word_ar: '&#x639;&#x64E;&#x644;&#x64E;&#x64A;&#x652;&#x643;&#x64F;&#x645;&#x652;',
//   )
// ];
String correctWord(WordModel word) {
  for (WordModel correctWord in CorrectWordData.replaceWords) {
    if (word.word_id == correctWord.word_id && word.ayaId == correctWord.ayaId) {
      return correctWord.word_ar!;
    }
  }
  return word.word_ar!;
}

bool isCorrect(WordModel word) {
  for (WordModel correctWord in CorrectWordData.replaceWords) {
    if (word.word_id == correctWord.word_id && word.ayaId == correctWord.ayaId) {
      return false;
    }
  }
  return true;
}

class SingleWordWidget extends StatelessWidget {
  const SingleWordWidget({
    super.key,
    required this.wordModel,
    required this.fontSize,
    required this.fontFamilyNum,
    required this.wordTagMap,
    required this.fontWeight,
  });
  final WordModel wordModel;
  final double fontSize;
  final int fontFamilyNum;
  final String fontWeight;
  final Map<int, List> wordTagMap;
  @override
  Widget build(BuildContext context) {
    bool isWordCorrect = isCorrect(wordModel);
    return SizedBox(
      // margin: const EdgeInsets.only(right: 20),
      child: Text(
        HtmlUnescape().convert(correctWord(wordModel)),
        // : '',
        // const HtmlEscape(HtmlEscapeMode.element).convert(pageLines[x][j].word_ar!),
        textAlign: TextAlign.justify,
        textScaleFactor: 1.0,
        style: isWordCorrect
            ? TextStyle(
                fontFamily: 'p$fontFamilyNum',
                fontSize: calcFontSize(fontSize, isSmall: true),
                color: _textColor(isWordCorrect),
                fontWeight: fontWeight == 'bold' ? FontWeight.bold : FontWeight.normal,
                fontStyle: FontStyle.normal,
              )
            : TextStyle(
                // fontFamily: 'p$fontFamilyNum',
                fontFamily: 'uthmanic2',
                fontSize: calcFontSize(fontSize, isSmall: true),
                color: _textColor(isWordCorrect),
                fontWeight: fontWeight == 'bold' ? FontWeight.bold : FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
      ),
    );
  }

  Color _textColor(bool isWordCorrect) {
    return wordModel.ayaId == searchResultId.value.toString() ||
            wordModel.ayaId == Get.find<ReadAyaController>().ayaId.toString()
        ? Colors.blue
        : SearchAyahData.wordsId.contains(int.parse(wordModel.word_id ?? '0'))
            ? Colors.green
            : getTagId(wordModel, wordTagMap) == null
                ? selectedAyaId.value == wordModel.ayaId!
                    // ? pr(readWordsColor, 'readWordsColor')
                    ? const Color(0xff000000)
                    : const Color(0xff000000)
                : _getTagColor(wordModel);
  }

  Color _getTagColor(WordModel wordModel) {
    try {
      int colorInt = hexToInteger(wordTagMap[int.parse(wordModel.word_id!)]?[1]);
      return Color(colorInt);
    } catch (e) {
      return Colors.green;
    }
  }
}
