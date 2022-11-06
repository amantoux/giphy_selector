import 'package:flutter/widgets.dart';

class GiphySelectorConfig extends InheritedWidget {
  static GiphySelectorConfig of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<GiphySelectorConfig>()!;

  const GiphySelectorConfig(
      {super.key,
      required this.apiKey,
      required this.randomID,
      required this.rating,
      required this.language,
      required super.child});

  final String apiKey;
  final String randomID;
  final String rating;
  final String language;

  @override
  bool updateShouldNotify(covariant GiphySelectorConfig oldWidget) =>
      oldWidget.apiKey != apiKey ||
      oldWidget.randomID != randomID ||
      oldWidget.rating != rating ||
      oldWidget.language != language;
}
