import 'dart:convert';

import 'package:dlalat_quaran_new/dialogs/custom_snack_bar.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:get/get.dart';

enum CommentType { ayah, article, tag }

class CommentController extends GetxController {
  static const String _domainLink = "https://ioqs.org/control-panel/api/v1/";
  static const String _addAyahComment = "addayahcomment";
  static const String _addArticleComment = "addarticlecomment";
  static const String _addTagComment = "addtagcomment";
  ResponseState responseState = ResponseState.initial;
  final DioConsumer dioConsumer;
  CommentController({required this.dioConsumer});
  Future<bool> addComment({
    required CommentType commentType,
    required int id,
    required String name,
    required String email,
    required String phone,
    required String comment,
  }) async {
    String path = _domainLink;
    switch (commentType) {
      case CommentType.ayah:
        path += _addAyahComment;
      case CommentType.article:
        path += _addArticleComment;
      case CommentType.tag:
        path += _addTagComment;
    }
    final t = 'addComment - CommentController $commentType';
    responseState = ResponseState.loading;
    try {
      final response = await dioConsumer.post(path, data: {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "comment": comment,
        "devicelocal": Get.locale?.languageCode ?? 'ar',
      });

      if (jsonDecode(response)['status'] == 'true') {
        pr(response, t);
        responseState = ResponseState.success;
        showCustomSnackBar(title: "شكرا", body: "تم أضافة تعليقكم بنجاح");
        return true;
      }
      pr('Error occured response: $response', t);
      responseState = ResponseState.failed;
      showCustomSnackBar(title: "خطأ", body: "نأسف لحدوث خطا و برجاء المحاولة مرة أخري", isSuccess: false);
      return false;
    } on Exception catch (e) {
      pr('Exeption occured: $e', t);
      responseState = ResponseState.failed;
      showCustomSnackBar(title: "خطأ", body: "نأسف لحدوث خطا و برجاء المحاولة مرة أخري", isSuccess: false);
      return false;
    }
  }
}
