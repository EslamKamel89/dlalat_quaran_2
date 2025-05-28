import 'dart:convert';

import 'package:dlalat_quaran_new/dialogs/custom_snack_bar.dart';
import 'package:dlalat_quaran_new/models/competition_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:get/get.dart';

abstract class CompetitionsData {
  static List<CompetitionModel> competitionsList = [];
  static List<CompetitionModel> filteredList = [];
}

class CompetitionsController extends GetxController {
  static const String _domainLink = "https://ioqs.org/control-panel/api/v1/";
  static const String _getAllQuestions = "allquestions";

  ResponseState getAllQuestionsResponseState = ResponseState.initial;
  ResponseState joinCompetitionResponseState = ResponseState.initial;

  final DioConsumer dioConsumer;
  CompetitionsController({required this.dioConsumer});

  Future<bool> getAllQuestions() async {
    const t = 'allQuestions - CompetitionsController ';
    pr('fetching data started', t);
    const path = _domainLink + _getAllQuestions;
    getAllQuestionsResponseState = ResponseState.loading;
    try {
      final response = await dioConsumer.get(path);
      pr(response, t);
      CompetitionsData.competitionsList =
          jsonDecode(response).map<CompetitionModel>((json) => CompetitionModel.fromJson(json)).toList();
      CompetitionsData.filteredList = CompetitionsData.competitionsList;
      getAllQuestionsResponseState = ResponseState.success;
      update();
      return true;
    } on Exception catch (e) {
      pr('Exeption occured: $e', t);
      getAllQuestionsResponseState = ResponseState.failed;
      showCustomSnackBar(title: "خطأ", body: "نأسف لحدوث خطا و برجاء المحاولة مرة أخري", isSuccess: false);
      update();
      return false;
    }
  }

  void search(String key) {
    if (key == "") {
      CompetitionsData.filteredList = CompetitionsData.competitionsList;
      update();
      return;
    }
    List<dynamic> filteredData = CompetitionsData.competitionsList.where(((x) => x.toString().contains(key))).toList();
    CompetitionsData.filteredList = filteredData as List<CompetitionModel>;
    update();
  }

  @override
  void onClose() {
    CompetitionsData.filteredList.clear();
    CompetitionsData.competitionsList.clear();
    update();
    super.onClose();
  }
}
