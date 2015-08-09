//
//  GEOLocations.m
//  AR Kit
//
//  Modified by Niels W Hansen on 12/19/09.
//  Modified by Ed Rackham (a1phanumeric) 2013
//

#import "GEOLocations.h"
#import "ARGeoCoordinate.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@implementation GEOLocations


@synthesize delegate;

- (id)initWithDelegate:(id<ARLocationDelegate>) aDelegate{
	[self setDelegate:aDelegate];
	return self;
}

- (NSMutableArray *)returnLocations{
	return [delegate geoLocations];
}

@end
