import 'package:flutter/widgets.dart';

import '../client/client.dart';

typedef OnSelectGiphyItem = void Function(GiphyGif);

class GiphySelectorConfig extends InheritedWidget {
  static GiphySelectorConfig of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<GiphySelectorConfig>()!;

  const GiphySelectorConfig(
      {super.key,
      required this.apiKey,
      required this.randomID,
      required this.rating,
      required this.language,
      this.onSelectGiphyItem,
      required super.child});

  final String apiKey;
  final String randomID;
  final String rating;
  final String language;
  final OnSelectGiphyItem? onSelectGiphyItem;

  @override
  bool updateShouldNotify(covariant GiphySelectorConfig oldWidget) =>
      oldWidget.apiKey != apiKey ||
      oldWidget.randomID != randomID ||
      oldWidget.rating != rating ||
      oldWidget.language != language;
}
