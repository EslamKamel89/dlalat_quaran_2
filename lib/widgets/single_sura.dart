import 'package:dlalat_quaran_new/models/sura_model.dart';
import 'package:dlalat_quaran_new/ui/sura_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/short_explanation_index_controller.dart';

class SingleSura extends StatelessWidget {
  final SuraModel suraModel;
  Widget destination;

  SingleSura(this.suraModel, this.destination, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          Get.delete<ShortExplainIndexController>();

          Get.to(destination,
              transition: Transition.fade,
              arguments: destination.runtimeType == SuraScreen().runtimeType
                  ? {'page': '${suraModel.page}'}
                  : suraModel.toJson());
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 50,
          child: Row(
            children: [
              Expanded(
                  child: Text(
                suraModel.toString(),
                style: const TextStyle(fontFamily: "Almarai", fontSize: 20),
              )),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}
