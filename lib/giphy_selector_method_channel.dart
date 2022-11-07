import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'giphy_selector_platform_interface.dart';

/// An implementation of [GiphySelectorPlatform] that uses method channels.
class MethodChannelGiphySelector extends GiphySelectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('giphy_selector');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
