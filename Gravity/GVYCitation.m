//
//  GVYCitation.m
//  Gravity
//
//  Created by Christopher Polito on 4/13/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import "GVYCitation.h"

@implementation GVYCitation

@synthesize date;

-(void) makeDate:(NSString *) dateString {
    
    //dateformat object
    GVYDateFormatter *dateFormatter = [[GVYDateFormatter alloc] init];
    
    //create date object from date string
    date = [dateFormatter dateFromString:dateString];
    
}

@end
