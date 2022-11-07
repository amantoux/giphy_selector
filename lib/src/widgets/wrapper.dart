import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giphy_selector/src/widgets/config.dart';

import '../client/client.dart';
import 'sheet.dart';

class GiphySelector {
  static Future<GiphyGif?> getGif({
    required BuildContext context,
    required String apiKey,
    String rating = GiphyRating.g,
    String lang = GiphyLanguage.english,
    String randomID = '',
    String searchText = '',
    String queryText = '',
    bool modal = true,
    Color? tabColor,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('apiKey must be not null or not empty');
    }

    return showModalBottomSheet<GiphyGif>(
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
      isScrollControlled: true,
      context: context,
      builder: (ctx) => GiphySelectorSheet(
        apiKey: apiKey,
        lang: lang,
        randomID: randomID,
        rating: rating,
        searchText: searchText,
        tabColor: tabColor,
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String apiKey,
    required OnSelectGiphyItem onSelectGiphyItem,
    String rating = GiphyRating.g,
    String lang = GiphyLanguage.english,
    String randomID = '',
    String searchText = '',
    String queryText = '',
    bool modal = true,
    Color? tabColor,
  }) {
    if (apiKey.isEmpty) {
      throw Exception('apiKey must be not null or not empty');
    }

    return showModalBottomSheet<GiphyGif>(
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (ctx) => GiphySelectorSheet(
        apiKey: apiKey,
        lang: lang,
        randomID: randomID,
        rating: rating,
        searchText: searchText,
        tabColor: tabColor,
        onSelectGiphyItem: onSelectGiphyItem,
      ),
    );
  }
}

typedef GiphySelectorWrapperBuilder = Widget Function(
    Stream<GiphyGif>, GiphySelectorWrapper);

class GiphySelectorWrapper extends StatelessWidget {
  final String apiKey;
  final GiphySelectorWrapperBuilder builder;
  final streamController = StreamController<GiphyGif>.broadcast();

  GiphySelectorWrapper({Key? key, required this.apiKey, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(streamController.stream, this);
  }

  getGif(String queryText, BuildContext context) async {
    GiphyGif? gif = await GiphySelector.getGif(
      queryText: queryText,
      context: context,
      apiKey: apiKey,
      lang: GiphyLanguage.spanish,
    );
    if (gif != null) streamController.add(gif);
  }
}
