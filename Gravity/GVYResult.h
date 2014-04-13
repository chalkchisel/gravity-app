//
//  GVYLocation.h
//  Gravity
//
//  Created by Christopher Polito on 4/12/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Mantle.h>
#import "GVYCitation.h"

@interface GVYResult : MTLModel <MTLJSONSerializing>

@property (retain, nonatomic) CLLocation *location;
@property (retain, nonatomic) NSNumber *accel;

@property (retain, nonatomic) GVYCitation *citation;


@end
