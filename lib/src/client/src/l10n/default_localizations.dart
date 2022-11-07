import 'lang/en.dart';
import 'lang/es.dart';
import 'lang/fr.dart';

abstract class GiphyGetUILocalizationLabels {
  const GiphyGetUILocalizationLabels();

  String get searchInputLabel;

  String get gifsLabel;

  String get stickersLabel;

  String get emojisLabel;

  String get viewOnGiphy;

  String get moreBy;

  String get poweredByGiphy;
}

const localizations = <String, GiphyGetUILocalizationLabels>{
  'en': EnLocalizations(),
  'fr': FrLocalizations(),
  'es': EsLocalizations()
};

class DefaultLocalizations extends EnLocalizations {
  const DefaultLocalizations();
}
