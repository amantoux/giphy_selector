import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giphy_selector/giphy_selector_method_channel.dart';

void main() {
  MethodChannelGiphySelector platform = MethodChannelGiphySelector();
  const MethodChannel channel = MethodChannel('giphy_selector');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
