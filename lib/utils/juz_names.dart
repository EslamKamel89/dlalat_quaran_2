import 'dart:developer';
import 'package:flutter/material.dart';

String juzArName(String no) {
  if (no != '') {
    int juzNo = int.parse(no);
    if (juzNo == 1) {
      no = 'الجزء الأول';
    } else if (juzNo == 2) {
      no = 'الجزء الثاني';
    } else if (juzNo == 3) {
      no = 'الجزء الثالث';
    } else if (juzNo == 4) {
      no = 'الجزء الرابع';
    } else if (juzNo == 5) {
      no = 'الجزء الخامس';
    } else if (juzNo == 6) {
      no = 'الجزء السادس';
    } else if (juzNo == 7) {
      no = 'الجزء السابع';
    } else if (juzNo == 8) {
      no = 'الجزء الثامن';
    } else if (juzNo == 9) {
      no = 'الجزء التاسع';
    } else if (juzNo == 10) {
      no = 'الجزء العاشر';
    } else if (juzNo == 11) {
      no = 'الجزء الحادي عشر';
    } else if (juzNo == 12) {
      no = 'الجزء الثاني عشر';
    } else if (juzNo == 13) {
      no = 'الجزء الثالث عشر';
    } else if (juzNo == 14) {
      no = 'الجزء الرابع عشر';
    } else if (juzNo == 15) {
      no = 'الجزء الخامس عشر';
    } else if (juzNo == 16) {
      no = 'الجزء السادس عشر';
    } else if (juzNo == 17) {
      no = 'الجزء السابع عشر';
    } else if (juzNo == 18) {
      no = 'الجزء الثامن عشر';
    } else if (juzNo == 19) {
      no = 'الجزء التاسع عشر';
    } else if (juzNo == 20) {
      no = 'الجزء العشرون';
    } else if (juzNo == 21) {
      no = 'الجزء الحادي والعشرون';
    } else if (juzNo == 22) {
      no = 'الجزء الثاني والعشرون';
    } else if (juzNo == 23) {
      no = 'الجزء الثالث والعشرون';
    } else if (juzNo == 24) {
      no = 'الجزء الرابع والعشرون';
    } else if (juzNo == 25) {
      no = 'الجزء الخامس والعشرون';
    } else if (juzNo == 26) {
      no = 'الجزء السادس والعشرون';
    } else if (juzNo == 27) {
      no = 'الجزء السابع والعشرون';
    } else if (juzNo == 28) {
      no = 'الجزء الثامن والعشرون';
    } else if (juzNo == 29) {
      no = 'الجزء التاسع والعشرون';
    } else if (juzNo == 30) {
      no = 'الجزء الثلاثون';
    }

    log('juzNames No = $no ');
  }
  return no;
}

String arabicNumber(int number) {
  String res = '';
  final arabicNo = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  for (var element in number.toString().characters) {
    res += arabicNo[int.parse(element)];
  }
  return res;
}
