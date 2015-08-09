//
//  ARLocationDelegate.h
//  AR Kit
//
//  Created by Jared Crawford on 2/13/10.
//  Modified by Ed Rackham (a1phanumeric) 2013
//

#import <Foundation/Foundation.h>
#import "ARGeoCoordinate.h"


@protocol ARLocationDelegate

//returns an array of ARGeoCoordinates
- (NSMutableArray *)geoLocations;
- (void)locationClicked:(ARGeoCoordinate *)coordinate;
- (void)didFinishSnapshotGeneration:(UIImage*)image error:(NSError*)error;
@end

