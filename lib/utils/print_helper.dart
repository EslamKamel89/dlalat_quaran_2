import 'package:flutter/foundation.dart';

bool _isIos = false;
T prx<T>(T variable, [String? title]) {
  return variable;
}

T pr<T>(T variable, [String? title]) {
  if (kDebugMode) {
    String message = '${_toRed("< eslam dev ${title == null ? "" : " - $title"}>")} '
        '${_toGreen(variable.toString())}';
    print(message);
  }
  return variable;
}

// yellow
String _toYellow(String text) {
  return text;
  return '\x1B[33m$text\x1B[0m';
}

// red
String _toRed(String text) {
  return text;
  return '\x1B[31m$text\x1B[0m';
}

// blue
String _toBlue(String text) {
  if (_isIos) return text;
  return '\x1B[34m$text\x1B[0m';
}

//green
String _toGreen(String text) {
  if (_isIos) return text;
  return '\x1B[32m$text\x1B[0m';
}
