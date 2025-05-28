import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/juz_names.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:dlalat_quaran_new/widgets/single_sura_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _editController = TextEditingController();
  WordSearchController searchController = Get.put(WordSearchController());
  final focusNode = FocusNode();

  SearchScreen({super.key});

  // Widget searchView() {
  //   SearchWidget searchWidget = SearchWidget(_editController, () {
  //     if(_editController.text.toString().isNotEmpty) {
  //       print("----------------------------++++++");
  //       searchController.search(_editController.text.toString());
  //       focusNode.unfocus();
  //     }
  //   });
  //   searchWidget.function =  (){  searchController.search(_editController.text.toString());};
  //   searchWidget.focusNode = focusNode;
  //   return searchWidget;
  // }

  @override
  Widget build(BuildContext context) {
    // _editController.text = searchController.searchKey;

    _editController.addListener(() {
      searchController.search(_editController.text.toString().toLowerCase());
    });
    return Column(
      children: [
        SearchWidget(_editController, null, () {
          searchController
              .search(_editController.text.toString().toLowerCase());
        }),
        Obx(() => searchController.wordCount.value == '0'
            ? const SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'اجمالي العدد : ',
                    style: TextStyle(
                        color: Colors.blueGrey, fontFamily: 'Almarai'),
                  ),
                  Text(
                    arabicNumber(int.parse(searchController.wordCount.value)),
                    style: const TextStyle(
                        color: primaryColor2, fontFamily: 'Almarai'),
                  ),
                ],
              )),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: Obx(() {
            return searchController.loading.value
                ? const SpinKitDualRing(
                    color: primaryColor,
                  )
                : searchController.resultList.isNotEmpty
                    ? ListView.builder(
                        itemCount: searchController.resultList.length,
                        itemBuilder: (context, index) {
                          var resultList = searchController.resultList[index];
                          resultList.searchKey =
                              _editController.text.toString();
                          return SingleSuraResultItem(
                              searchController.resultList[index]);
                        },
                      )
                    : const SizedBox();
          }),
        )
      ],
    );
  }
}
