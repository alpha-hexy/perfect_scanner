import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_scanner/src/perfect_scanner_method_channel.dart';

void main() {
  MethodChannelPerfectScanner platform = MethodChannelPerfectScanner();
  const MethodChannel channel = MethodChannel('perfect_scanner');

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
