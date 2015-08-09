//
//  Radar.h
//  ARKitDemo
//
//  Created by Ed Rackham (a1phanumeric) 2013
//  Based on mixare's implementation.
//

#import <UIKit/UIKit.h>
#import "ARGeoCoordinate.h"

#define RADIUS 60.0

@interface Radar : UIView

@property (nonatomic, strong) NSArray *pois;
@property (nonatomic, assign) float radius;

@property (strong, nonatomic) UIColor *radarBackgroundColour;
@property (strong, nonatomic) UIColor *pointColour;

@end
