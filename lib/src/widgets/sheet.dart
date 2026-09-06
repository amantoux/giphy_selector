import 'package:material_ui/material_ui.dart';

import '../client/client.dart';
import 'config.dart';
import 'search_controller.dart' as intern;
import 'selector.dart';

class const GiphySelectorSheet({
  super.key,
  required this.apiKey,
  final OnSelectGiphyItem? onSelectGiphyItem,
  final String? searchText,
  final String rating = GiphyRating.g,
  final String lang = GiphyLanguage.english,
  final String randomID = '',
  final Color? tabColor,
}) extends StatefulWidget {
  final String apiKey;

  @override
  State<GiphySelectorSheet> createState() => GiphySelectorSheetState();
}

const double _minExtent = 0.7;
const double _maxExtent = 0.95;

class GiphySelectorSheetState extends GiphySelectorContainer<GiphySelectorSheet>
    with SingleTickerProviderStateMixin {
  final _searchController = intern.SearchController('');

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
              const GiphyTabBottom(),
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
