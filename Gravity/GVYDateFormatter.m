//
//  GVYDateFormatter.m
//  Gravity
//
//  Created by Christopher Polito on 4/13/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import "GVYDateFormatter.h"

@implementation GVYDateFormatter



-(id) init {
    
    self = [super init];
    
    if (self) {
        
        dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        
        [self setDateFormat:dateFormat];
        
    }
    
    return self;
}

@end
