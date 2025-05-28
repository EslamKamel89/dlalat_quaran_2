import 'package:dlalat_quaran_new/controllers/search_ayah_controller.dart';
import 'package:dlalat_quaran_new/models/aya_model.dart';
import 'package:dlalat_quaran_new/ui/search_by_ayah/widgets/dropdown_item_card.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/replace_arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class AyaSearchableDropdown extends StatefulWidget {
  const AyaSearchableDropdown({super.key});

  @override
  State<AyaSearchableDropdown> createState() => _AyaSearchableDropdownState();
}

class _AyaSearchableDropdownState extends State<AyaSearchableDropdown> {
  SearchAyahController searchAyahController = Get.find<SearchAyahController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // textEditingController?.clear();
    super.dispose();
  }

  List<AyaModel> search(String search) {
    if (search == '') {
      return SearchAyahData.ayas;
    }
    String ayaId = replaceArabicNumbers(search);
    return SearchAyahData.ayas.where((aya) {
      try {
        return int.parse(aya.verseKey?.split(':').last ?? '0') == int.parse(ayaId);
      } on Exception catch (_) {
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // DataBaseHelper.dataBaseInstance().getAyaBySuaId(widget.selectedSuraModel?.id ?? 0);
    // return const Text('Todo');
    return GetBuilder<SearchAyahController>(builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TypeAheadField<AyaModel>(
          emptyBuilder: (_) => const DropdownItemDisplayCard(content: 'لا يوجد بيانات'),
          suggestionsCallback: search,
          builder: (context, controller, focusNode) {
            controller.text = searchAyahController.selectedAyaModel?.verseKey?.split(':').last ?? '';
            return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffix: IconButton(
                      onPressed: () {
                        controller.clear();
                      },
                      icon: const Icon(Icons.clear)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  labelText: 'رقم الأية',
                ));
          },
          itemBuilder: (context, aya) {
            return DropdownItemDisplayCard(content: "(${aya.verseKey}) ${aya.textAr ?? ''}");
          },
          onSelected: (aya) {
            searchAyahController.updateSelectedAya(aya);
            pr(aya.id, 'AyaSearchableDropdown widget - aya id');
            if (aya.ayah != null && searchAyahController.selectedSuraModel?.id != null) {
              searchAyahController.getWordsIdsByAyahId((searchAyahController.selectedSuraModel?.id)!, aya.ayah!);
            }
            setState(() {});
          },
        ),
      );
    });
  }
}
