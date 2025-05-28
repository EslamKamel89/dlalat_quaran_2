import 'dart:io';

import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/api_service/upload_file_to_api.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:get/get.dart';

abstract class AddResearchData {
  static File? uploadFile;
}

class AddResearchController extends GetxController {
  static const String _domainLink = "https://ioqs.org/control-panel/api/v1/";
  static const String _addResearch = "addresearch";

  ResponseState addResearchResponseState = ResponseState.initial;

  final DioConsumer dioConsumer;
  AddResearchController({required this.dioConsumer});

  Future<bool> addResearch({
    required String email,
    required String name,
    required String phone,
    required String comment,
  }) async {
    var t = 'addResearch - AddResearchController';
    pr('posting data started', t);

    const path = _domainLink + _addResearch;
    addResearchResponseState = ResponseState.loading;
    try {
      final response = await dioConsumer.post(
        path,
        data: {
          "email": email,
          "name": name,
          "phone": phone,
          "comment": comment,
          "devicelocal": Get.locale?.toLanguageTag() ?? 'ar',
          "file": await uploadFileToApi(AddResearchData.uploadFile!),
        },
        isFormData: true,
      );
      pr(response, t);
      addResearchResponseState = ResponseState.success;
      update();
      return true;
    } on Exception catch (e) {
      pr('Exeption occured: $e', t);
      addResearchResponseState = ResponseState.failed;
      update();
      return false;
    }
  }

  @override
  void onClose() {
    AddResearchData.uploadFile = null;
    update();
    super.onClose();
  }
}
