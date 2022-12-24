import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giphy_selector/src/widgets/config.dart';
import 'package:giphy_selector/src/widgets/modal.dart';

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
    ModalOptions? modalOptions,
    Color? tabColor,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('apiKey must be not null or not empty');
    }
    if (modalOptions != null) {
      return Navigator.of(context, rootNavigator: true).push(
        RawDialogRoute(
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          pageBuilder: (context, _, __) {
            return Stack(
              children: [
                Positioned(
                  top: modalOptions.alignment.isBottom
                      ? modalOptions.anchor.dy
                      : null,
                  bottom: modalOptions.alignment.isTop
                      ? modalOptions.anchor.dy
                      : null,
                  left: modalOptions.alignment.isRight
                      ? modalOptions.anchor.dx
                      : null,
                  right: modalOptions.alignment.isLeft
                      ? modalOptions.anchor.dx
                      : null,
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 400, maxWidth: 400),
                    color: Colors.red,
                    child: GiphySelectorModal(
                      apiKey: apiKey,
                      lang: lang,
                      randomID: randomID,
                      rating: rating,
                      searchText: searchText,
                      tabColor: tabColor,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      );
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
    ModalOptions? modalOptions,
    Color? tabColor,
  }) {
    if (apiKey.isEmpty) {
      throw Exception('apiKey must be not null or not empty');
    }

    if (modalOptions != null) {
      final mediaQuery = MediaQuery.of(context);
      return Navigator.of(context).push(
        RawDialogRoute(
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          pageBuilder: (context, _, __) {
            return Stack(
              children: [
                Positioned(
                  top: modalOptions.alignment.isBottom
                      ? modalOptions.anchor.dy
                      : null,
                  bottom: modalOptions.alignment.isTop
                      ? mediaQuery.size.height - modalOptions.anchor.dy
                      : null,
                  left: modalOptions.alignment.isRight
                      ? modalOptions.anchor.dx
                      : null,
                  right: modalOptions.alignment.isLeft
                      ? mediaQuery.size.width - modalOptions.anchor.dx
                      : null,
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 400, maxWidth: 400),
                    color: Colors.red,
                    child: GiphySelectorModal(
                      apiKey: apiKey,
                      lang: lang,
                      randomID: randomID,
                      rating: rating,
                      searchText: searchText,
                      tabColor: tabColor,
                      onSelectGiphyItem: onSelectGiphyItem,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      );
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

  getGif(String queryText, BuildContext context,
      {ModalOptions? modalOptions}) async {
    GiphyGif? gif = await GiphySelector.getGif(
      queryText: queryText,
      context: context,
      apiKey: apiKey,
      lang: GiphyLanguage.spanish,
      modalOptions: modalOptions,
    );
    if (gif != null) streamController.add(gif);
  }
}

class ModalOptions {
  ModalOptions(this.anchor, this.alignment);

  final Offset anchor;
  final Alignment alignment;
}

extension on Alignment {
  bool get isBottom => y == 1.0;

  bool get isTop => y == -1.0;

  bool get isLeft => x == -1.0;

  bool get isRight => x == 1.0;
}
