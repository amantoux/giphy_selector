import 'package:flutter/material.dart';

import '../client/client.dart';
import 'config.dart';
import 'search_controller.dart';
import 'selector.dart';

class GiphySelectorSheet extends StatefulWidget {
  const GiphySelectorSheet(
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
  State<GiphySelectorSheet> createState() => GiphySelectorSheetState();
}

const double _minExtent = 0.7;
const double _maxExtent = 0.95;

class GiphySelectorSheetState extends GiphySelectorContainer<GiphySelectorSheet>
    with SingleTickerProviderStateMixin {
  final _searchController = SearchController("");

  late TabController _tabController;
  late ScrollController _scrollController;

  bool isExpanded = false;
  String? _tabType;
  double _initialExtent = _minExtent;

  @override
  String? get tabType => _tabType;

  @override
  set tabType(value) {
    if (mounted) setState(() => _tabType = value);
  }

  double get initialExtent => _initialExtent;

  set initialExtent(double iExtent) => setState(() => _initialExtent = iExtent);

  bool get isExtentToMin => initialExtent == _minExtent;

  void setInitialExtentToMax() => initialExtent = _maxExtent;

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
    return GiphySelectorConfig(
      apiKey: widget.apiKey,
      randomID: widget.randomID,
      rating: widget.rating,
      language: widget.lang,
      onSelectGiphyItem: widget.onSelectGiphyItem,
      child: DraggableScrollableSheet(
        expand: isExpanded,
        minChildSize: _minExtent,
        maxChildSize: _maxExtent,
        initialChildSize: initialExtent,
        builder: (ctx, scrollController) {
          _scrollController = scrollController;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const GiphyTabTop(),
              GiphyTabBar(
                tabController: _tabController,
                color: widget.tabColor,
              ),
              SearchAppBar(
                scrollController: _scrollController,
                searchController: _searchController,
                focusNode: focus,
                focusListener: _focusListener,
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
          );
        },
      ),
    );
  }

  void _focusListener(FocusNode focus) {
    if (focus.hasFocus && initialExtent == _minExtent) {
      initialExtent = _maxExtent;
    }
  }
}
