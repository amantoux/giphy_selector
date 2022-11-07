import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../client/client.dart';
import 'config.dart';
import 'search_controller.dart';

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

class GiphySelectorSheetState extends State<GiphySelectorSheet>
    with SingleTickerProviderStateMixin {
  static GiphySelectorSheetState of(BuildContext context) =>
      context.findAncestorStateOfType<GiphySelectorSheetState>()!;

  final _searchController = SearchController("");

  late TabController _tabController;
  late ScrollController _scrollController;

  bool isExpanded = false;
  String? _tabType;
  double _initialExtent = _minExtent;

  String? get tabType => _tabType;

  set tabType(value) {
    if (mounted) setState(() => _tabType = value);
  }

  double get initialExtent => _initialExtent;

  set initialExtent(double iExtent) => setState(() => _initialExtent = iExtent);

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
}

class GiphyTabBar extends StatefulWidget {
  const GiphyTabBar({Key? key, required this.tabController, this.color})
      : super(key: key);
  final TabController tabController;
  final Color? color;

  @override
  State<GiphyTabBar> createState() => _GiphyTabBarState();
}

class _GiphyTabBarState extends State<GiphyTabBar> {
  late List<Tab> _tabs;

  @override
  void didChangeDependencies() {
    widget.tabController.addListener(() {
      _setTabType(widget.tabController.index, context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setTabType(0, context);
    });
    final labels = GiphyGetUILocalizations.labelsOf(context);
    _tabs = [
      Tab(text: labels.gifsLabel),
      Tab(text: labels.stickersLabel),
      Tab(text: labels.emojisLabel)
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      unselectedLabelColor: Theme.of(context).brightness == Brightness.light
          ? Colors.black54
          : Colors.white54,
      labelColor: widget.color ?? Theme.of(context).colorScheme.secondary,
      indicatorColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.label,
      controller: widget.tabController,
      tabs: _tabs,
      onTap: (int pos) => _setTabType(pos, context),
    );
  }

  _setTabType(int pos, BuildContext context) {
    final sheetState = GiphySelectorSheetState.of(context);
    switch (widget.tabController.index) {
      case 0:
        sheetState.tabType = GiphyType.gifs;
        break;
      case 1:
        sheetState.tabType = GiphyType.stickers;
        break;
      default:
        sheetState.tabType = GiphyType.emoji;
    }
  }
}

class GiphyTabTop extends StatefulWidget {
  const GiphyTabTop({Key? key}) : super(key: key);

  @override
  State<GiphyTabTop> createState() => _GiphyTabTopState();
}

class _GiphyTabTopState extends State<GiphyTabTop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: 50,
      height: 2,
      color: Theme.of(context).textTheme.bodyText1!.color!,
    );
  }
}

class SearchAppBar extends StatefulWidget {
  const SearchAppBar(
      {Key? key,
      required this.scrollController,
      required this.searchController})
      : super(key: key);

  final ScrollController scrollController;
  final SearchController searchController;

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  late TextEditingController _textEditingController;

  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    _focus.addListener(_focusListener);
    _textEditingController =
        TextEditingController(text: widget.searchController.value);
    _textEditingController.addListener(() {
      if (widget.searchController.value != _textEditingController.text) {
        widget.searchController.value = _textEditingController.text;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = GiphyGetUILocalizations.labelsOf(context);
    final sheetState = GiphySelectorSheetState.of(context);
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
      child: Column(
        children: [
          sheetState.tabType == GiphyType.emoji
              // ? Container(height: 40.0, child: _giphyLogo())
              ? Container()
              : SizedBox(
                  height: 40,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        autofocus: false,
                        focusNode: _focus,
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: kIsWeb
                              ? const Icon(Icons.search)
                              : ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                        Color(0xFFFF6666),
                                        Color(0xFF9933FF),
                                      ]).createShader(bounds),
                                  child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(pi),
                                      child: const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      )),
                                ),
                          hintText: l.searchInputLabel,
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color!,
                              ),
                              onPressed: () {
                                setState(() {
                                  _textEditingController.clear();
                                });
                              }),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        autocorrect: false,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _focusListener() {
    final sheetState = GiphySelectorSheetState.of(context);
    if (_focus.hasFocus && sheetState.initialExtent == _minExtent) {
      sheetState.initialExtent = _maxExtent;
    }
  }
}

class GiphyTabBottom extends StatelessWidget {
  const GiphyTabBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(child: _giphyLogo(context)),
    );
  }

  Widget _giphyLogo(BuildContext context) {
    const basePath = "assets/img/";
    String logoPath = Theme.of(context).brightness == Brightness.light
        ? "poweredby_dark.png"
        : "poweredby_light.png";

    return Container(
      width: double.maxFinite,
      height: 15,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage(
                "$basePath$logoPath",
                package: 'giphy_get',
              ))),
    );
  }
}

class GiphyTabView extends StatelessWidget {
  const GiphyTabView(
      {Key? key,
      required this.scrollController,
      required this.tabController,
      required this.searchController})
      : super(key: key);

  final ScrollController scrollController;
  final TabController tabController;
  final SearchController searchController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        GiphyTabDetail(
          type: GiphyType.gifs,
          scrollController: scrollController,
          searchController: searchController,
          key: null,
        ),
        GiphyTabDetail(
          type: GiphyType.stickers,
          scrollController: scrollController,
          searchController: searchController,
        ),
        GiphyTabDetail(
          type: GiphyType.emoji,
          scrollController: scrollController,
          searchController: searchController,
        )
      ],
    );
  }
}

class GiphyTabDetail extends StatefulWidget {
  const GiphyTabDetail(
      {Key? key,
      required this.type,
      required this.scrollController,
      required this.searchController})
      : super(key: key);

  final String type;
  final ScrollController scrollController;
  final SearchController searchController;

  @override
  State<GiphyTabDetail> createState() => _GiphyTabDetailState();
}

class _GiphyTabDetailState extends State<GiphyTabDetail> {
  final Axis _scrollDirection = Axis.vertical;
  final double _spacing = 8.0;

  late int _crossAxisCount;
  late double _gifWidth;
  late int _limit;

  GiphyCollection? _collection;
  List<GiphyGif> _list = [];

  bool _isLoading = false;
  int offset = 0;

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case GiphyType.gifs:
        _gifWidth = 200.0;
        break;
      case GiphyType.stickers:
        _gifWidth = 150.0;
        break;
      case GiphyType.emoji:
        _gifWidth = 80.0;
        break;
      default:
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.scrollController.addListener(_scrollListener);
    widget.searchController.addListener(_listenerQuery);
    _crossAxisCount = (MediaQuery.of(context).size.width / _gifWidth).round();
    int mainAxisCount =
        ((MediaQuery.of(context).size.height - 30) / _gifWidth).round();
    _limit = _crossAxisCount * mainAxisCount;
    offset = 0;
    _loadMore();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_list.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final config = GiphySelectorConfig.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      // child: StaggeredGrid.countB
      child: MasonryGridView.count(
        scrollDirection: _scrollDirection,
        controller: widget.scrollController,
        itemCount: _list.length,
        crossAxisCount: _crossAxisCount,
        mainAxisSpacing: _spacing,
        crossAxisSpacing: _spacing,
        itemBuilder: (ctx, idx) {
          GiphyGif gif = _list[idx];
          double aspectRatio = (double.parse(gif.images!.fixedWidth.width) /
              double.parse(gif.images!.fixedWidth.height));
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: InkWell(
              onTap: () => (config.onSelectGiphyItem ?? _selectedGif).call(gif),
              child: gif.images == null || gif.images?.fixedWidth.webp == null
                  ? Container()
                  : Image.network(
                      gif.images!.fixedWidth.webp!,
                      gaplessPlayback: true,
                      fit: BoxFit.fill,
                      headers: const {'accept': 'image/*'},
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return AspectRatio(
                          aspectRatio: aspectRatio,
                          child: Container(color: Theme.of(context).cardColor),
                        );
                      },
                      errorBuilder: (context, exception, stackTrace) {
                        return AspectRatio(
                          aspectRatio: aspectRatio,
                          child: Container(
                            color: Theme.of(context).cardColor,
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadMore() async {
    //Return if is loading or no more gifs
    if (_isLoading || _collection?.pagination?.totalCount == _list.length) {
      return;
    }

    _isLoading = true;
    final config = GiphySelectorConfig.of(context);
    final client =
        GiphyClient(apiKey: config.apiKey, randomId: config.randomID);

    // Offset pagination for query
    if (_collection == null) {
      offset = 0;
    } else {
      offset = _collection!.pagination!.offset + _collection!.pagination!.count;
    }

    // Get Gif or Emoji
    if (widget.type == GiphyType.emoji) {
      _collection = await client.emojis(offset: offset, limit: _limit);
    } else {
      final query = widget.searchController.value;
      if (query.isNotEmpty) {
        _collection = await client.search(query,
            lang: config.language,
            offset: offset,
            rating: config.rating,
            type: widget.type,
            limit: _limit);
      } else {
        _collection = await client.trending(
            lang: config.language,
            offset: offset,
            rating: config.rating,
            type: widget.type,
            limit: _limit);
      }
    }

    // Set result to list
    if (_collection!.data.isNotEmpty && mounted) {
      setState(() {
        _list.addAll(_collection!.data);
      });
    }

    _isLoading = false;
  }

  void _scrollListener() {
    if (widget.scrollController.positions.last.extentAfter < 500 &&
        !_isLoading) {
      _loadMore();
    }
  }

  void _selectedGif(GiphyGif gif) {
    Navigator.pop(context, gif);
  }

  void _listenerQuery() {
    _collection = null;
    _list = [];
    _loadMore();
  }
}
