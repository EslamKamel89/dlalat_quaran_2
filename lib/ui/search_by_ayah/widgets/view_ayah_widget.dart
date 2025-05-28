import 'package:dlalat_quaran_new/models/aya_model.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:flutter/material.dart';

class ViewAyahWidget extends StatelessWidget {
  const ViewAyahWidget({super.key, required this.ayaModel});
  final AyaModel? ayaModel;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        // height: 200,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(child: DefaultText(ayaModel?.textAr ?? '')),
      ),
    );
  }
}
