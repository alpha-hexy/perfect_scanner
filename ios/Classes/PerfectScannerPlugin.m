#import "PerfectScannerPlugin.h"
#if __has_include(<perfect_scanner/perfect_scanner-Swift.h>)
#import <perfect_scanner/perfect_scanner-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "perfect_scanner-Swift.h"
#endif

@implementation PerfectScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPerfectScannerPlugin registerWithRegistrar:registrar];
}
@end
