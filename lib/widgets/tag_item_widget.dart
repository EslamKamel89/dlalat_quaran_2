import 'package:dlalat_quaran_new/models/tag_model.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagItemWidget extends StatelessWidget {
  final TagModel tagModel;
  final Widget destination;

  const TagItemWidget(this.tagModel, this.destination, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        // onPressed: () => Get.to(destination, transition: Transition.fade, arguments: tagModel.toJson()),
        onPressed: () => Get.to(destination, transition: Transition.fade, arguments: tagModel.id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          // height: ,
          child: Row(
            children: [
              Expanded(
                child: ArabicText(
                  tagModel.name(),
                  fontSize: 15,
                  color: Colors.black,
                ),
                // Text(
                //   tagModel.name(),
                //   // '${tagModel.name()}لوريم ايبسوم دولار سيت أميت ,كونسيكتيتور  . يوت انيم أد مينيم أيا كوممودو كونسيكيوات . ',
                //   style: const TextStyle(
                //     // fontFamily: "Almarai",
                //     fontSize: 15,
                //     color: Colors.black,
                //   ),
                // ),
              ),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}
