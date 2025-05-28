import 'package:dlalat_quaran_new/controllers/search_ayah_controller.dart';
import 'package:dlalat_quaran_new/ui/new_single_sura_screen.dart';
import 'package:dlalat_quaran_new/ui/search_by_ayah/widgets/aya_searchable_dropdown.dart';
import 'package:dlalat_quaran_new/ui/search_by_ayah/widgets/sura_searchable_dropdown.dart';
import 'package:dlalat_quaran_new/ui/search_by_ayah/widgets/view_ayah_widget.dart';
import 'package:dlalat_quaran_new/ui/sura_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:dlalat_quaran_new/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchAyahcreen extends StatefulWidget {
  const SearchAyahcreen({super.key});

  @override
  State<SearchAyahcreen> createState() => _SearchAyahcreenState();
}

class _SearchAyahcreenState extends State<SearchAyahcreen> {
  final focusNode = FocusNode();

  SearchAyahController searchAyahController = Get.put(SearchAyahController());
  @override
  void initState() {
    searchAyahController.clearData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _editController.text = searchController.searchKey;
    return GetBuilder<SearchAyahController>(builder: (_) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
                visible:
                    searchAyahController.selectedSuraModel != null && searchAyahController.selectedAyaModel != null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: PrimaryButton(
                    onPressed: () {
                      searchAyahController.clearData();
                    },
                    borderRadius: 10,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: const DefaultText('بحث أخر', color: Colors.white),
                    ),
                  ),
                )),
            Visibility(
              visible: searchAyahController.selectedSuraModel == null || searchAyahController.selectedAyaModel == null,
              child: Column(
                children: [
                  const SuraSearchableDropdown(),
                  Visibility(
                      visible: searchAyahController.selectedSuraModel != null, child: const AyaSearchableDropdown()),
                ],
              ),
            ),
            searchAyahController.selectedAyaModel != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DefaultText(
                          'نتيجة البحث',
                          fontSize: 20,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ViewAyahWidget(ayaModel: searchAyahController.selectedAyaModel),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                          width: double.infinity,
                          height: 650,
                          child: NewSingleSuraScreen(searchAyahController.selectedAyaModel?.page ?? 1)),
                      Align(
                        alignment: Alignment.center,
                        child: PrimaryButton(
                            onPressed: () {
                              Get.to(const SuraScreen(),
                                  arguments: {'page': '${searchAyahController.selectedAyaModel?.page ?? 1}'});
                            },
                            borderRadius: 10,
                            child: const DefaultText(
                              'الذهاب ألي ألاية',
                              color: Colors.white,
                            )),
                      ),
                    ],
                  )
                : const SizedBox()
          ],
        ),
      );
    });
  }
}
