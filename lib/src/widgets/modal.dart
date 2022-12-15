import 'package:flutter/material.dart';

import '../client/client.dart';
import 'config.dart';
import 'search_controller.dart';
import 'selector.dart';

class GiphySelectorModal extends StatefulWidget {
  const GiphySelectorModal(
      {Key? key,
      required this.apiKey,
      this.onSelectGiphyItem,
      this.searchText,
      this.rating = GiphyRating.g,
      this.lang = GiphyLanguage.english,
      this.randomID = '',
      this.tabColor})
      : super(key: key);

  final String apiKey;
  final OnSelectGiphyItem? onSelectGiphyItem;
  final String? searchText;
  final String rating;
  final String lang;
  final String randomID;
  final Color? tabColor;

  @override
  State<GiphySelectorModal> createState() => GiphySelectorModalState();
}

class GiphySelectorModalState extends GiphySelectorContainer<GiphySelectorModal>
    with SingleTickerProviderStateMixin {
  final _searchController = SearchController("");

  late TabController _tabController;
  final _scrollController = ScrollController();

  bool isExpanded = false;
  String? _tabType;

  @override
  String? get tabType => _tabType;

  @override
  set tabType(String? value) {
    if (mounted) setState(() => _tabType = value);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      child: GiphySelectorConfig(
        apiKey: widget.apiKey,
        randomID: widget.randomID,
        rating: widget.rating,
        language: widget.lang,
        onSelectGiphyItem: widget.onSelectGiphyItem,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GiphyTabBar(
              tabController: _tabController,
              color: widget.tabColor,
            ),
            SearchAppBar(
              scrollController: _scrollController,
              searchController: _searchController,
            ),
            Expanded(
              child: GiphyTabView(
                tabController: _tabController,
                scrollController: _scrollController,
                searchController: _searchController,
              ),
            ),
            const GiphyTabBottom()
          ],
        ),
      ),
    );
  }
}
