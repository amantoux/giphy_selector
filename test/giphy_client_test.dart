import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:giphy_get/giphy_selector.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements Client {}

Future<void> main() async {
  var apiKey = Platform.environment['GIPHY_API_KEY'] ?? '';

  group('GiphyClient', () {
    test('should fetch trending gifs', () async {
      final client = GiphyClient(
        apiKey: apiKey,
        randomId: '',
      );

      final collection = await client.trending();

      expect(collection, const TypeMatcher<GiphyCollection>());
    });

    test('should search gifs', () async {
      final client = GiphyClient(
        apiKey: apiKey,
        randomId: '',
      );

      final collection = await client.search('');

      expect(collection, const TypeMatcher<GiphyCollection>());
    });

    test('should fetch emojis', () async {
      final client = GiphyClient(
        apiKey: apiKey,
        randomId: '',
      );

      final collection = await client.emojis();

      expect(collection, const TypeMatcher<GiphyCollection>());
    });

    test('should load a random gif', () async {
      final client = GiphyClient(
        apiKey: apiKey,
        randomId: '',
      );

      final gif = await client.random(tag: '');

      expect(gif, const TypeMatcher<GiphyGif>());
    });

    test('should load a gif by id', () async {
      final client = GiphyClient(
        apiKey: apiKey,
        randomId: '',
      );

      final gif = await client.byId('l46Cc0Ped9R0uiTkY');

      expect(gif, const TypeMatcher<GiphyGif>());
      expect(gif.title?.toLowerCase(),
          'Beyonce freedom GIF by BET Awards'.toLowerCase());
    });

    test('should parse gifs correctly', () async {
      final client = GiphyClient(
        apiKey: apiKey,
        randomId: '',
      );

      // Gif Validation
      final gif = (await client.trending()).data.first;
      expect(gif.rating, GiphyRating.g);
      expect(gif.type, 'gif');
    });

    test('should parse users correctly', () async {
      final client = GiphyClient(
        apiKey: apiKey,
        randomId: '',
      );

      // Gif Validation
      final user = (await client.trending()).data.first.user;

      expect(user?.profileUrl, isNotNull);
    });

    test('should parse images correctly', () async {
      final client = GiphyClient(
        apiKey: apiKey,
        randomId: '',
      );

      // Gif Validation
      final images = (await client.trending()).data.first.images;
      expect(images!.fixedHeightStill, const TypeMatcher<GiphyStillImage>());
      expect(images.originalStill, const TypeMatcher<GiphyStillImage>());
      // expect(images.fixedWidth, GiphyFullImage());
      expect(
          images.fixedHeightSmallStill, const TypeMatcher<GiphyStillImage>());
      // expect(
      //   images.fixedHeightDownsampled,
      //   GiphyDownsampledImage(),
      // );
      expect(images.preview, const TypeMatcher<GiphyPreviewImage>());
      expect(images.fixedHeightSmall, const TypeMatcher<GiphyFullImage>());
      expect(images.downsizedStill, const TypeMatcher<GiphyStillImage>());
      expect(images.downsized, const TypeMatcher<GiphyDownsizedImage>());
      expect(images.downsizedLarge, const TypeMatcher<GiphyDownsizedImage>());
      expect(images.fixedWidthSmallStill, const TypeMatcher<GiphyStillImage>());
      expect(images.previewWebp, const TypeMatcher<GiphyWebPImage>());
      expect(images.fixedWidthStill, const TypeMatcher<GiphyStillImage>());
      expect(images.fixedWidthSmall, const TypeMatcher<GiphyFullImage>());
      expect(images.downsizedSmall, const TypeMatcher<GiphyPreviewImage>());
      expect(images.downsizedMedium, const TypeMatcher<GiphyPreviewImage>());
      expect(images.original, const TypeMatcher<GiphyOriginalImage>());
      expect(images.fixedHeight, const TypeMatcher<GiphyFullImage>());
      expect(images.looping, const TypeMatcher<GiphyLoopingImage>());
      expect(images.originalMp4, const TypeMatcher<GiphyPreviewImage>());
      expect(images.previewGif, const TypeMatcher<GiphyDownsizedImage>());
      expect(images.w480Still, const TypeMatcher<GiphyStillImage>());
    });
  });
}
