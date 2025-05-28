import 'package:dlalat_quaran_new/controllers/search_ayah_controller.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/sura_model.dart';
import 'package:dlalat_quaran_new/ui/search_by_ayah/widgets/dropdown_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class SuraSearchableDropdown extends StatefulWidget {
  const SuraSearchableDropdown({super.key});

  @override
  State<SuraSearchableDropdown> createState() => _SuraSearchableDropdownState();
}

class _SuraSearchableDropdownState extends State<SuraSearchableDropdown> {
  SearchAyahController searchAyahController = Get.find<SearchAyahController>();

  @override
  void initState() {
    DataBaseHelper.dataBaseInstance()
        .suraIndex()
        .then((value) => SearchAyahData.suras = value)
        .then((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    // textEditingController?.clear();
    super.dispose();
  }

  List<SuraModel> search(String search) {
    // if (widget.selectedAyaModel != null) {
    //   widget.updateAyahScreenState(ayaModel: null, suraMode: null);
    // }
    if (search == '') {
      return SearchAyahData.suras;
    }
    return SearchAyahData.suras.where((sura) {
      return sura.name().toLowerCase().contains(search.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchAyahController>(builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TypeAheadField<SuraModel>(
          emptyBuilder: (_) => const DropdownItemDisplayCard(content: 'لا يوجد بيانات'),
          suggestionsCallback: search,
          builder: (context, controller, focusNode) {
            controller.text = searchAyahController.selectedSuraModel?.name() ?? '';
            return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  suffix: IconButton(
                      onPressed: () {
                        controller.clear();
                      },
                      icon: const Icon(Icons.clear)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  labelText: 'أختر السورة',
                ));
          },
          itemBuilder: (context, sura) {
            return DropdownItemDisplayCard(content: sura.name());
          },
          onSelected: (sura) {
            searchAyahController.updateSelectedSura(sura);

            // pr(sura, '123456');
            setState(() {});
          },
        ),
      );
    });
  }
}
