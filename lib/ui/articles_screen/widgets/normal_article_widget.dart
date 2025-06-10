import 'package:dlalat_quaran_new/controllers/articles_controller.dart';
import 'package:dlalat_quaran_new/utils/is_internet_available.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:dlalat_quaran_new/widgets/articles_widgets.dart';
import 'package:dlalat_quaran_new/widgets/articles_widgets_loading.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NormalArticlesWidget extends StatefulWidget {
  const NormalArticlesWidget({super.key});

  @override
  State<NormalArticlesWidget> createState() => _NormalArticlesWidgetState();
}

class _NormalArticlesWidgetState extends State<NormalArticlesWidget> {
  final ArticlesController _articlesController = Get.find<ArticlesController>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    ArticlesData.filteredList = ArticlesData.articlesList;
    _getArticles();
    super.initState();
  }

  Future<void> _getArticles() async {
    if (await isInternetAvailable()) {
      _fetchData().then((_) => _fetchData());
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels >= 0.9 * _scrollController.position.maxScrollExtent) {
          await _fetchData();
        }
      });
    } else {
      _fetchData();
    }
    _searchController.addListener(() {
      _articlesController.search(_searchController.text.toString().toLowerCase());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    ArticlesData.filteredList = ArticlesData.articlesList;
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (!_isLoading && _articlesController.hasNextPage) {
      _isLoading = true;
      await _articlesController.allArticles();
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArticlesController>(
      builder: (context) {
        return ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  SearchWidget(_searchController, null, () {
                    _articlesController.search(_searchController.text.toString().toLowerCase());
                  }),
                  ArticlesData.filteredList.isEmpty &&
                          _articlesController.responseState == ResponseState.success
                      ? const Center(child: DefaultText('لا يوجد بيانات'))
                      : const SizedBox(),
                ],
              );
            }
            index = index - 1;
            if (index < ArticlesData.filteredList.length) {
              return ArticleCardWidget(ArticlesData.filteredList[index]);
            }
            return _articlesController.responseState == ResponseState.loading
                ? const ArticlesWidgetLodingColumn()
                : const SizedBox();
          },
          itemCount: ArticlesData.filteredList.length + 2,
        );
      },
    );
  }
}
