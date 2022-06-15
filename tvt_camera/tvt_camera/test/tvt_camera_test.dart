import 'package:flutter_test/flutter_test.dart';
import 'package:tvt_camera/tvt_camera.dart';
import 'package:tvt_camera/tvt_camera_platform_interface.dart';
import 'package:tvt_camera/tvt_camera_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTvtCameraPlatform 
    with MockPlatformInterfaceMixin
    implements TvtCameraPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TvtCameraPlatform initialPlatform = TvtCameraPlatform.instance;

  test('$MethodChannelTvtCamera is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTvtCamera>());
  });

  test('getPlatformVersion', () async {
    TvtCamera tvtCameraPlugin = TvtCamera();
    MockTvtCameraPlatform fakePlatform = MockTvtCameraPlatform();
    TvtCameraPlatform.instance = fakePlatform;
  
    expect(await tvtCameraPlugin.getPlatformVersion(), '42');
  });
}
