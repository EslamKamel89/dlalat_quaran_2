import 'package:dlalat_quaran_new/controllers/tags_screen_controller.dart';
import 'package:dlalat_quaran_new/ui/tag_details_screen.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:dlalat_quaran_new/widgets/tag_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DifferenceTagsWidgt extends StatefulWidget {
  const DifferenceTagsWidgt({super.key});

  @override
  State<DifferenceTagsWidgt> createState() => DifferenceTagsWidgtState();
}

class DifferenceTagsWidgtState extends State<DifferenceTagsWidgt> {
  final TagsScreenController _tagsController = Get.find<TagsScreenController>();

  late TextEditingController _textEditingController;
  @override
  void initState() {
    // TagsScreenData.filteredList = [];
    // TagsScreenData.tagsList = [];
    if (TagsScreenData.tagsDifferenceList.isEmpty) {
      _tagsController.getTags(tagType: TagType.difference);
    }
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.addListener(() {
      _tagsController.search(
        key: _textEditingController.text.toString().toLowerCase(),
        tagType: TagType.difference,
      );
    });
    return GetBuilder<TagsScreenController>(builder: (context) {
      return _tagsController.responseState == ResponseState.loading
          ? const Center(child: CircularProgressIndicator())
          : TagsScreenData.filteredDifferenceList.isEmpty
              ? const Center(child: DefaultText('لا يوجد بيانات'))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return SearchWidget(_textEditingController, null, () {
                        _tagsController.search(
                          key: _textEditingController.text.toString().toLowerCase(),
                          tagType: TagType.difference,
                        );
                      });
                    }
                    index--;
                    return TagItemWidget(TagsScreenData.filteredDifferenceList[index], const TagDetailsScreen());
                  },
                  itemCount: TagsScreenData.filteredDifferenceList.length + 1,
                );
    });
  }
}
