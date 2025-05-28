import 'package:flutter/material.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

// ignore: must_be_immutable
class SearchWidget extends StatelessWidget {
  final TextEditingController _editingController;
  VoidCallback? function;
  FocusNode? focusNode;
  VoidCallback? onSubmittedfunction;
  SearchWidget(this._editingController, this.function, this.onSubmittedfunction,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [BoxShadow(color: mediumGray, blurRadius: 10)]),
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            focusNode: focusNode,
            style: const TextStyle(fontFamily: 'Almarai'),
            controller: _editingController,
            decoration: InputDecoration(
                hintText: 'search'.tr,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(0)),
            onSubmitted: (value) {
              print("value   -------------------------- $value");
              onSubmittedfunction;
              // Trigger search when Enter is pressed
            },
          )),
          InkWell(
            onTap: function,
            child: const Icon(Icons.search),
          )
        ],
      ),
    );
  }
}
