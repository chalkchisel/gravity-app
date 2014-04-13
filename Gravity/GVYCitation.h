//
//  GVYCitation.h
//  Gravity
//
//  Created by Christopher Polito on 4/13/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVYDateFormatter.h"

@interface GVYCitation : NSObject
{
    NSDate *date;
}


@property (retain, nonatomic) NSDate *date;
@property (retain, nonatomic) NSString *author;
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *publisher;

-(void) makeDate:(NSString *) dateString;

@end
