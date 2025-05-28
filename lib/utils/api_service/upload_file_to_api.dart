import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dlalat_quaran_new/dialogs/custom_snack_bar.dart';
import 'package:file_picker/file_picker.dart';

Future<MultipartFile> uploadFileToApi(File file) async {
  return await MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
}

Future<File?> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    File file = File(result.files.single.path!);
    return file;
  } else {
    showCustomSnackBar(title: 'خطأ', body: 'لم يتم أختيار ملف ', isSuccess: false);
    return null;
  }
}
