import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_video_log/service/camera_service.dart';

const cameraMethodChannel = MethodChannel('plugins.flutter.io/camera');
final cameraService = CameraService();

Future<dynamic> cameraCallHandler(MethodCall methodCall) async {
  if (methodCall.method == 'availableCameras') return [];
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
        .setMockMethodCallHandler(cameraMethodChannel, cameraCallHandler);
    cameraService.init();
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
        .setMockMethodCallHandler(cameraMethodChannel, null);
  });

  test('getAvailableCameras', () {
    expect(cameraService.getAvailableCameras().isEmpty, true);
  });
}