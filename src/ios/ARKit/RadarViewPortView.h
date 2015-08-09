//
//  RadarViewPortView.h
//  ARKitDemo
//
//  Created by Ed Rackham (a1phanumeric) 2013
//  Based on mixare's implementation.
//

#import <UIKit/UIKit.h>
#import "Radar.h"

@interface RadarViewPortView : UIView

@property (assign, nonatomic) float referenceAngle;
@property (strong, nonatomic) UIColor *viewportColour;

@end
