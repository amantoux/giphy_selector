# Giphy Selector

[![pub package](https://img.shields.io/pub/v/giphy_selector.svg)](https://pub.dartlang.org/packages/giphy_selector)

## Overview

Inspired by [giphy_get](https://github.com/bazookon/giphy_get)

This package allow to get gifs, sticker or emojis from [GIPHY](https://www.giphy.com/) in pure dart
code using [Giphy SDK](https://developers.giphy.com/docs/sdk) design guidelines.

<img src="https://github.com/amantoux/giphy_selector/raw/main/example/assets/demo/giphy_selector_widget.gif" width="360" />

## Getting Started

Important! you must register your app at [Giphy Develepers](https://developers.giphy.com/dashboard/)
and get your APIKEY

## Localizations

Currently english, french and spanish is supported.

```dart
void runApp() {
  return MaterialApp(
    title: ' Demo',
    localizationsDelegates: [
      // Default Delegates 
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      // Add this line 
      GiphyGetUILocalizations.delegate
    ],
    supportedLocales: [

      //Your supported languages
      Locale('en', ''),
      Locale('es', ''),
      Locale('fr', ''),
    ],
    home: MyHomePage(title: ' Demo'),
  );
}
```

### Get only Gif

This is for get gif without wrapper and tap to more

```dart 
import 'package:giphy_selector/giphy_selector.dart';

GiphyGif gif = await GiphySelector.getGif(
  context: context, //Required
  apiKey: "your api key HERE", //Required.
  lang: GiphyLanguage.english, //Optional - Language for query.
  randomID: "abcd", // Optional - An ID/proxy for a specific user.
  modalOptions: ModalOptions( // Option - Show Giphy selector in a modal
    Offset.zero,
    Alignment.topLeft
  ),
  tabColor:Colors.teal, // Optional- default accent color.
);
```

### Options

| Value         | Type         | Description                                                                                                      | Default                         |
|---------------|--------------|------------------------------------------------------------------------------------------------------------------|---------------------------------|
| `lang`        | String       | Use [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) language code or use GiphyLanguage constants            | `GiphyLanguage.english`         | 
| `randomID`    | String       | An ID/proxy for a specific user.                                                                                 | `null`                          | 
| `searchText`  | String       | Input search hint, we recommend use [flutter_18n package](https://pub.dev/packages/flutter_i18n) for translation | `"Search GIPHY"`                |
| `modalOptions` | ModalOptions | When not `null`, is used to position the Giphy selector in a modal                                               | `null`                          
| `tabColor`    | Color        | Color for tabs and loading progress,                                                                             | `Theme.of(context).accentColor` | 

### [Get Random ID](https://developers.giphy.com/docs/api/endpoint#random-id)

```dart
Futurew<void> doSomeThing() async {
  GiphyClient giphyClient = GiphyClient(apiKey: 'YOUR API KEY');
  String randomId = await giphyClient.getRandomId();
}
```

# Widgets

Optional but this widget is required if you get more gif's of user or view on Giphy following Giphy
Design guidelines

![giphy](https://developers.giphy.com/branch/master/static/attribution@2x-d66dd0ec49c03f6ba401354859bfca13.png)

## GiphyGifWidget

Parameters

| Value                      | Type            | Description                                                                                                                                  | Default          |
|----------------------------|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| `gif` required             | GiphyGif        | GiphyGif object from stream or JSON                                                                                                          |                  |       
| `giphyGetWrapper` required | GiphyGetWrapper | selector instance used to find more by author                                                                                                | null             |
| `showGiphyLabel`           | bool            | show or hide `Powered by GIPHY`label at bottom                                                                                               | true             |
| `borderRadius`             | BorderRadius    | add border radius to image                                                                                                                   | null             |
| `imageAlignment`           | Alignment       | this widget is a [Stack](https://api.flutter.dev/flutter/widgets/Stack-class.html) with Image and tap buttons this property adjust alignment | Alignment.center |

## GiphyGetWrapper

Parameters

| Value                    | Type     | Description                                                 | Default |
|--------------------------|----------|-------------------------------------------------------------|---------|
| `giphy_api_key` required | String   | Your Giphy API KEY                                          | null    | 
| `builder`                | function | return  Stream\<GiphyGif\> and Instance of  GiphyGetWrapper | null    |

## Available methods

```dart
void getGif(String queryText, BuildContext context);
```

```dart
void build(BuildContext context) {
  return GiphyGetWrapper(
      giphy_api_key: 'REPLACE_WITH YOUR_API_KEY',
      // Builder with Stream<GiphyGif> and Instance of GiphyGetWrapper
      builder: (stream, giphyGetWrapper) =>
          StreamBuilder<GiphyGif>(
              stream: stream,
              builder: (context, snapshot) {
                return Scaffold(
                  body: snapshot.hasData
                      ? SizedBox(
                    // GiphyGifWidget with tap to more
                    child: GiphyGifWidget(
                      imageAlignment: Alignment.center,
                      gif: snapshot.data,
                      giphyGetWrapper: giphyGetWrapper,
                      borderRadius: BorderRadius.circular(30),
                      showGiphyLabel: true,
                    ),
                  )
                      : Text("No GIF"),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      //Open Giphy Sheet
                      giphyGetWrapper.getGif('', context);
                    },
                    tooltip: 'Open Sticker',
                    child: Icon(Icons.insert_emoticon),
                  ),
                );
              }
          )
  );
}
```

## Using the example

First export your giphy api key

```terminal
export GIPHY_API_KEY=YOUR_GIPHY_API_KEY 
```

and then run.

## Contrib

Feel free to make any PR's
