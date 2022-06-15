import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tvt_camera/tvt_camera_method_channel.dart';

void main() {
  MethodChannelTvtCamera platform = MethodChannelTvtCamera();
  const MethodChannel channel = MethodChannel('tvt_camera');

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
