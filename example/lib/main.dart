import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:giphy_selector/giphy_selector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await dotenv.load(mergeWith: Platform.environment);
  } else {
    await dotenv.load();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giphy Get Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GiphyGetUILocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('fr', ''),
      ],
      home: const MyHomePage(title: 'Giphy Get Demo'),
      themeMode: ThemeMode.system,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GiphyGif currentGif;
  GiphyClient client;
  String randomId = "";
  String giphyApiKey = dotenv.get('GIPHY_API_KEY');

  @override
  void initState() {
    super.initState();

    client = GiphyClient(apiKey: giphyApiKey, randomId: '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      client.getRandomId().then((value) {
        setState(() {
          randomId = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GiphySelectorWrapper(
        apiKey: giphyApiKey,
        builder: (stream, giphyGetWrapper) {
          stream.listen((gif) {
            setState(() {
              currentGif = gif;
            });
          });

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Image.asset("assets/img/GIPHY Transparent 18px.png"),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text("Demo")
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Random ID: $randomId"),
                    const Text(
                      "Selected GIF",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    currentGif != null
                        ? SizedBox(
                            child: GiphyGifWidget(
                              imageAlignment: Alignment.center,
                              gif: currentGif,
                              giphyGetWrapper: giphyGetWrapper,
                              borderRadius: BorderRadius.circular(30),
                              showGiphyLabel: true,
                            ),
                          )
                        : const Text("No GIF")
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  giphyGetWrapper.getGif('', context);
                },
                tooltip: 'Open Sticker',
                child: const Icon(Icons
                    .insert_emoticon)), // This trailing comma makes auto-formatting nicer for build methods.
          );
        });
  }
}
