import 'dart:io';

import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/api_service/upload_file_to_api.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:get/get.dart';

abstract class JoinCompetitionData {
  static File? uploadFile;
}

class JoinCompetitionController extends GetxController {
  static const String _domainLink = "https://ioqs.org/control-panel/api/v1/";
  static const String _joinCompetition = "addquestionreply";

  ResponseState joinCompetitionResponseState = ResponseState.initial;

  final DioConsumer dioConsumer;
  JoinCompetitionController({required this.dioConsumer});

  Future<bool> joinCompetition({
    required int id,
    required String email,
    required String name,
    required String phone,
    required String comment,
  }) async {
    var t = 'joinCompetition - JoinCompetitionController - id: $id ';
    pr('posting data started', t);

    const path = _domainLink + _joinCompetition;
    joinCompetitionResponseState = ResponseState.loading;
    try {
      final response = await dioConsumer.post(
        path,
        data: {
          "id": id,
          "email": email,
          "name": name,
          "phone": phone,
          "comment": comment,
          "devicelocal": Get.locale?.toLanguageTag() ?? 'ar',
          "file": await uploadFileToApi(JoinCompetitionData.uploadFile!),
        },
        isFormData: true,
      );
      pr(response, t);
      joinCompetitionResponseState = ResponseState.success;
      update();
      return true;
    } on Exception catch (e) {
      pr('Exeption occured: $e', t);
      joinCompetitionResponseState = ResponseState.failed;
      update();
      return false;
    }
  }

  @override
  void onClose() {
    JoinCompetitionData.uploadFile = null;
    update();
    super.onClose();
  }
}
