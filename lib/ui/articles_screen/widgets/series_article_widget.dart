import 'package:dlalat_quaran_new/controllers/article_series_controller.dart';
import 'package:dlalat_quaran_new/dialogs/custom_snack_bar.dart';
import 'package:dlalat_quaran_new/ui/articles_screen/widgets/series_article_card_widget.dart';
import 'package:dlalat_quaran_new/utils/is_internet_available.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/text_styles.dart';
import 'package:dlalat_quaran_new/widgets/articles_widgets_loading.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeriesArticlesWidget extends StatefulWidget {
  const SeriesArticlesWidget({super.key});

  @override
  State<SeriesArticlesWidget> createState() => SeriesArticlesWidgetState();
}

class SeriesArticlesWidgetState extends State<SeriesArticlesWidget> {
  final ArticlesSeriesController _articlesController = Get.find<ArticlesSeriesController>();
  // final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final bool _isLoading = false;
  @override
  void initState() {
    ArticlesSeriesData.articleSeries = [];
    ArticlesSeriesData.filteredList = [];
    _getArticleSeries();
    super.initState();
  }

  Future<void> _getArticleSeries() async {
    if (await isInternetAvailable()) {
      _articlesController.getArticleSeries();
      // _fetchData().then((_) => _fetchData());
      // _scrollController.addListener(() async {
      //   if (_scrollController.position.pixels >= 0.9 * _scrollController.position.maxScrollExtent) {
      //     await _fetchData();
      //   }
      // });
    } else {
      showCustomSnackBarNoInternet();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> _fetchData() async {
  //   if (!_isLoading && _articlesController.hasNextPage) {
  //     _isLoading = true;
  //     await _articlesController.getArticleSeries();
  //     _isLoading = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _searchController.addListener(() {
      _articlesController.search(_searchController.text.toString().toLowerCase());
    });
    return GetBuilder<ArticlesSeriesController>(
      builder: (context) {
        return ArticlesSeriesData.filteredList.isEmpty &&
                _articlesController.responseState == ResponseState.loading
            ? const ArticlesWidgetLodingColumn()
            : ListView.builder(
              // controller: _scrollController,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      SearchWidget(_searchController, null, () {
                        _articlesController.search(_searchController.text.toString().toLowerCase());
                      }),
                      ArticlesSeriesData.filteredList.isEmpty
                          ? const Center(child: DefaultText('لا يوجد بيانات'))
                          : const SizedBox(),
                    ],
                  );
                }
                index = index - 1;
                if (index < ArticlesSeriesData.filteredList.length) {
                  return SeriesArticleCardWidget(ArticlesSeriesData.filteredList[index]);
                }
                return _articlesController.responseState == ResponseState.loading
                    ? const ArticlesWidgetLodingColumn()
                    : const SizedBox();
              },
              itemCount: ArticlesSeriesData.filteredList.length + 2,
            );
      },
    );
  }
}
