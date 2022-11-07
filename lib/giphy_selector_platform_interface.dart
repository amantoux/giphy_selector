import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'giphy_selector_method_channel.dart';

abstract class GiphySelectorPlatform extends PlatformInterface {
  /// Constructs a GiphySelectorPlatform.
  GiphySelectorPlatform() : super(token: _token);

  static final Object _token = Object();

  static GiphySelectorPlatform _instance = MethodChannelGiphySelector();

  /// The default instance of [GiphySelectorPlatform] to use.
  ///
  /// Defaults to [MethodChannelGiphySelector].
  static GiphySelectorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GiphySelectorPlatform] when
  /// they register themselves.
  static set instance(GiphySelectorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
