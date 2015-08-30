#import <Cordova/CDV.h>
#import <CoreLocation/CoreLocation.h>
#import "ARKit.h"

@interface CsAR : CDVPlugin <ARLocationDelegate, CLLocationManagerDelegate>

- (void)canDoAR: (CDVInvokedUrlCommand*)command;
- (void)showGeolocationsForSelection: (CDVInvokedUrlCommand*)command;

@end
