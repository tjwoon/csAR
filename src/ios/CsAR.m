#import "CsAR.h"

@interface CsAR ()

@property CDVInvokedUrlCommand *callback;
@property NSMutableArray *geoLocations;

@end


@implementation CsAR

@synthesize callback;
@synthesize geoLocations;

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

    // Get arguments - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Validity is checked in JS.

    NSDictionary *args = (NSDictionary*) [command argumentAtIndex:0
                                                  withDefault:nil
                                                  andClass:[NSDictionary class]];

    NSNumber *radarRange = [args objectForKey:@"maxDistance"];
    NSArray *locs = [args objectForKey:@"geoLocations"];

    [self ingestGeoLocations:locs];

    // Save callback and display AR view - - - - - - - - - - - - - - - - - - - -

    callback = command;

    ARViewController *controller = [[ARViewController alloc] initWithDelegate:self];
    //[controller setShowsRadar:YES];
    //[controller setRadarBackgroundColour:[UIColor blackColor]];
    //[controller setRadarViewportColour:[UIColor darkGrayColor]];
    //[controller setRadarPointColour:[UIColor whiteColor]];
    [controller setRadarRange:[radarRange doubleValue]];
    [controller setOnlyShowItemsWithinRadarRange:YES];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal]; // ? TODO CHECK FIXME
    [self.viewController presentViewController:controller animated:YES completion:nil];
}


#pragma mark -
#pragma mark ARLocationDelegate

- (void)locationClicked:(ARGeoCoordinate *)coordinate
{
    NSLog(@"LOCATION CLICKED NATIVE, %@", coordinate); // TMP

    CLLocationCoordinate2D clLoc = coordinate.geoLocation.coordinate;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:coordinate.title, @"name"
                                                                   ,clLoc.latitude,   @"latitude"
                                                                   ,clLoc.longitude,  @"longitude"
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
