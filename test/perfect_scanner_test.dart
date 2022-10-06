// import 'package:flutter_test/flutter_test.dart';
// import 'package:perfect_scanner/perfect_scanner.dart';
// import 'package:perfect_scanner/perfect_scanner_platform_interface.dart';
// import 'package:perfect_scanner/perfect_scanner_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockPerfectScannerPlatform
//     with MockPlatformInterfaceMixin
//     implements PerfectScannerPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final PerfectScannerPlatform initialPlatform = PerfectScannerPlatform.instance;

//   test('$MethodChannelPerfectScanner is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelPerfectScanner>());
//   });

//   test('getPlatformVersion', () async {
//     PerfectScanner perfectScannerPlugin = PerfectScanner();
//     MockPerfectScannerPlatform fakePlatform = MockPerfectScannerPlatform();
//     PerfectScannerPlatform.instance = fakePlatform;

//     expect(await perfectScannerPlugin.getPlatformVersion(), '42');
//   });
// }
