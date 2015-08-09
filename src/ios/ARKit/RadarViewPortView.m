//
//  RadarViewPortView.m
//  ARKitDemo
//
//  Created by Ed Rackham (a1phanumeric) 2013
//  Based on mixare's implementation.
//

#import "RadarViewPortView.h"
#define radians(x) (M_PI * (x) / 180.0)

@implementation RadarViewPortView{
    float _newAngle;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _newAngle               = 45.0;
        _referenceAngle         = 247.5;
        self.backgroundColor    = [UIColor clearColor];
        _viewportColour         = [UIColor colorWithRed:14.0/255.0 green:140.0/255.0 blue:14.0/255.0 alpha:0.5];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, _viewportColour.CGColor);
    CGContextMoveToPoint(contextRef, RADIUS, RADIUS);
    CGContextAddArc(contextRef, RADIUS, RADIUS, RADIUS,  radians(_referenceAngle), radians(_referenceAngle+_newAngle),0);
    CGContextClosePath(contextRef);
    CGContextFillPath(contextRef);
}


@end
