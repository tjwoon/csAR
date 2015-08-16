#import "CsAR.h"

@interface CsAR ()

@property CDVInvokedUrlCommand *callback;
@property CLLocationManager *locationManager;

// Config/state per run...
@property NSMutableArray *geoLocations;
@property double radarRange;

@end


@implementation CsAR

@synthesize callback;
@synthesize locationManager;
@synthesize geoLocations;
@synthesize radarRange;

#pragma mark -
#pragma mark Helpers

- (void)sendErrorString: (NSString*)msg withCommand:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                               messageAsString:msg];
    [self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
}

- (void)ingestGeoLocations: (NSArray*)locs
{
    NSMutableArray *ingested = [[NSMutableArray alloc] initWithCapacity:[locs count]];

    for(NSDictionary *loc in locs) {
        double lat = [[loc objectForKey:@"latitude"] doubleValue];
        double lng = [[loc objectForKey:@"longitude"] doubleValue];
        NSString *name = [loc objectForKey:@"name"];
        CLLocation *clLoc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        ARGeoCoordinate *arCoord = [ARGeoCoordinate coordinateWithLocation:clLoc
                                                    locationTitle:name];
        [ingested addObject:arCoord];
    }

    self.geoLocations = ingested;
}

- (void)requestLocationPermissions
{
    if(self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
    }

    [self.locationManager requestWhenInUseAuthorization];
}

- (void)startARWithGeoLocations
{
    ARViewController *controller = [[ARViewController alloc] initWithDelegate:self];
    // TMP FIXME [controller setShowsRadar:YES];
    // TMP FIXME [controller setRadarBackgroundColour:[UIColor blackColor]];
    // TMP FIXME [controller setRadarViewportColour:[UIColor darkGrayColor]];
    // TMP FIXME [controller setRadarPointColour:[UIColor whiteColor]];
    [controller setRadarRange:self.radarRange];
    [controller setOnlyShowItemsWithinRadarRange:YES];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal]; // ? TODO CHECK FIXME
    [self.viewController presentViewController:controller animated:YES completion:nil];
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager*)manager
        didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch(status) {
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            [self sendErrorString:@"Location permission not granted" withCommand:self.callback];
        case kCLAuthorizationStatusNotDetermined:
            return;
        default:
            [self startARWithGeoLocations];
    }
}


#pragma mark -
#pragma mark Plugin API

- (void)canDoAR: (CDVInvokedUrlCommand*)command
{
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                            messageAsBool:[ARKit deviceSupportsAR]]
                          callbackId:[command callbackId]];
}

/***
 * - showWithGeolocations
 * args: [
 *     {
 *         maxDistance: 1234
 *         geoLocations: [
 *             {
 *                 longitude: 123.456
 *                 latitude: 1.23
 *                 name: "Location name"
 *             }
 *             ...
 *         ]
 *     }
 * ]
 ***/
- (void)showWithGeolocations: (CDVInvokedUrlCommand*)command
{
    // Ensure we don't display more than one AR view at a time - - - - - - - - -

    if(callback != nil) {
        [self sendErrorString:@"AR is already in progress." withCommand:command];
        return;
    }

    // Get arguments and save for use  - - - - - - - - - - - - - - - - - - - - -
    // Validity is checked in JS.

    NSDictionary *args = (NSDictionary*) [command argumentAtIndex:0
                                                  withDefault:nil
                                                  andClass:[NSDictionary class]];

    NSNumber *radarRange = [args objectForKey:@"maxDistance"];
    self.radarRange = [radarRange doubleValue];

    NSArray *locs = [args objectForKey:@"geoLocations"];
    [self ingestGeoLocations:locs];

    callback = command;

    // Check for / request Location Services permissions - - - - - - - - - - - -

    switch([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            [self sendErrorString:@"Location permission not granted" withCommand:command];
            return;
        case kCLAuthorizationStatusNotDetermined:
            [self requestLocationPermissions];
            break;
        default:
            [self startARWithGeoLocations];
    }
}


#pragma mark -
#pragma mark ARLocationDelegate

- (void)locationClicked:(ARGeoCoordinate *)coordinate
{
    CLLocationCoordinate2D clLoc = coordinate.geoLocation.coordinate;
    NSNumber *lat = [NSNumber numberWithDouble:clLoc.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:clLoc.longitude];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:coordinate.title, @"name"
                                                                   ,lat, @"latitude"
                                                                   ,lon, @"longitude"
                                                                   ,NULL];

    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                               messageAsDictionary:dict];

    [self.commandDelegate sendPluginResult:result callbackId:[self.callback callbackId]];
}

- (void)didFinishSnapshotGeneration:(UIImage*)image error:(NSError*)error
{
    // Ignore this - our plugin does not need this / not sure exactly how this
    // is triggered.
}

@end
