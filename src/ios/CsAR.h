#import <Cordova/CDV.h>
#import "ARKit.h"

@interface CsAR : CDVPlugin <ARLocationDelegate>

- (void)canDoAR: (CDVInvokedUrlCommand*)command;
- (void)showWithGeolocations: (CDVInvokedUrlCommand*)command;

@end
