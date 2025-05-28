import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

Future<MultipartFile> uploadImageToApi(XFile image) async {
  return await MultipartFile.fromFile(image.path,
      filename: image.path.split('/').last);
}
