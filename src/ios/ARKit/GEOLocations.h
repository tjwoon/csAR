//
//  GEOLocations.h
//  AR Kit
//
//  Created by Niels W Hansen on 12/19/09.
//  Modified by Ed Rackham (a1phanumeric) 2013
//

#import <Foundation/Foundation.h>
#import "ARLocationDelegate.h"
 
@class ARCoordinate;

@interface GEOLocations : NSObject

@property(nonatomic,assign) id<ARLocationDelegate> delegate;

- (id)initWithDelegate:(id<ARLocationDelegate>) aDelegate;
-(NSMutableArray*) returnLocations;




@end
