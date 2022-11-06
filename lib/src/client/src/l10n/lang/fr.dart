import '../default_localizations.dart';

class FrLocalizations extends GiphyGetUILocalizationLabels {
  @override
  final String searchInputLabel;

  @override
  final String emojisLabel;

  @override
  final String gifsLabel;

  @override
  final String stickersLabel;

  @override
  final String moreBy;

  @override
  final String viewOnGiphy;

  @override
  final String poweredByGiphy;

  const FrLocalizations({
    this.searchInputLabel = 'Rechercher dans GIPHY',
    this.emojisLabel = 'Emojis',
    this.gifsLabel = 'GIFs',
    this.stickersLabel = 'Stickers',
    this.moreBy = 'Plus par',
    this.viewOnGiphy = 'Voir sur GIPHY',
    this.poweredByGiphy = 'Fourni par GIPHY',
  });
}
