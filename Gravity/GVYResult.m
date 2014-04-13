//
//  GVYLocation.m
//  Gravity
//
//  Created by Christopher Polito on 4/12/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import "GVYResult.h"

@implementation GVYResult


+(NSDictionary *) JSONKeyPathsByPropertyKey {
    
    //map -- this object's members:JSON object keys
    return @{
             @"accel":@"acceleration",
             @"location":@"location.coordinates",
             @"citation":@"source"
             };
}

+(NSValueTransformer *) locationJSONTransformer {
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSArray *array) {
        
        //JSON returns an NSArray for location
        
        NSNumber *longitude = [array objectAtIndex:0];
        NSNumber *lat = [array objectAtIndex:1];
        
        
        //return location object defined by lat and long
        return [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[longitude doubleValue]];
    } reverseBlock:^(CLLocation *location) {
        
        return [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:location.coordinate.longitude], [NSNumber numberWithDouble:location.coordinate.latitude], nil];
    }];
}

//+(NSValueTransformer *) accelJSONTransformer {
//    
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *gravity) {
//        
//        return gravity;
//    } reverseBlock:^(NSNumber *gravity) {
//        
//        return gravity;
//    }];
//}

+(NSValueTransformer *) citationJSONTransformer {
    
    
    //JSON keys for "source" object
    NSString static *cite1Key = @"Date";
    NSString static *cite2Key = @"Author/Site";
    NSString static *cite3Key = @"URL";
    NSString static *cite4Key = @"Publisher";
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *object) {
        
        
        //citation object
        GVYCitation *citation = [[GVYCitation alloc] init];
        
        //get date object from JSON string with format
        [citation makeDate:[object objectForKey:cite1Key]];
        
        //citation members are NSStrings
        citation.author = [object objectForKey:cite2Key];
        citation.url = [object objectForKey:cite3Key];
        citation.publisher = [object objectForKey:cite4Key];
        
        return citation;
    } reverseBlock:^(GVYCitation *citation) {
        
        NSDictionary *JSONdict = [[NSDictionary alloc] init];
        
        //create date formatter object with ISO 8601
        GVYDateFormatter *dateFormatter = [[GVYDateFormatter alloc] init];
        
        //get string from date object
        NSString *dateString = [dateFormatter stringFromDate:citation.date];
        
        //set dictionary values with keys
        [JSONdict setValue:dateString forKey:cite1Key];
        [JSONdict setValue:citation.author forKey:cite2Key];
        [JSONdict setValue:citation.url forKey:cite3Key];
        [JSONdict setValue:citation.publisher forKey:cite4Key];
        
        return JSONdict;
    }];

}



@end
