#import "StripeIdealPlugin.h"
#if __has_include(<stripe_ideal/stripe_ideal-Swift.h>)
#import <stripe_ideal/stripe_ideal-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "stripe_ideal-Swift.h"
#endif

@implementation StripeIdealPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftStripeIdealPlugin registerWithRegistrar:registrar];
}
@end
