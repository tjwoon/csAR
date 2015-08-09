//
//  ARKit.h
//  AR Kit
//
//  Modified by Niels Hansen on 11/20/11.
//  Modified by Ed Rackham (a1phanumeric) 2013
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "ARViewController.h"
#import "ARLocationDelegate.h"

@interface ARKit : NSObject

+ (BOOL)deviceSupportsAR;

@end
