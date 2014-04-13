//
//  GVYHTTPCaller.m
//  Gravity
//
//  Created by Christopher Polito on 4/12/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import "GVYHTTPCaller.h"

@implementation GVYHTTPCaller

-(RACSignal*)getGravity:(NSString *)string
{

	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		//string is @"lat=#####&long=#####"

		NSLog(@"run caller");

		//common URL for webservice
		NSString *baseURL = @"http://gravity-backend.herokuapp.com/api/v1/location/?";


		//combine baseURL with lat and long
		NSString *query = [[NSString alloc] initWithFormat:@"%@%@", baseURL, string];
		NSURL *url = [NSURL URLWithString:query];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];


		//http request
		AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
		op.responseSerializer = [AFJSONResponseSerializer serializer];


		//on complete or failure
		[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id response) {

			NSDictionary *dict = (NSDictionary *) response;

			GVYResult *result;

			//check if there is a webservice error
			NSString *errorString = [dict objectForKey:@"error"];

			if (errorString != nil) {
				// if webservice error

				result = [[GVYResult alloc] init];

				result.location =  nil;
				result.accel = [NSNumber numberWithDouble:0.0];

				NSLog(@"response failure: %@", errorString);

			}
			else {
				// if no webservice error

				//mantle error
				NSError *error;

				//print response
				for (id key in dict) {
					NSLog(@"key: %@, value: %@", key, [dict objectForKey:key]);
				}

				//process response with Mantle

				//            NSString static *cite1Key = @"Author/Site";
				//            NSString *dateString = [dict objectForKey:cite1Key];
				//
				//            NSLog(@"dateString is %@", dateString);

				result = [MTLJSONAdapter modelOfClass:GVYResult.class fromJSONDictionary:dict error:&error];


				//log success, error will be (null) if mantle was successful
				NSLog(@"HTTP success, gravity = %f, with mantel error is %@", [result.accel doubleValue], error);
			}

			[subscriber sendNext:result];
			[subscriber sendCompleted];

//			//send notification with GVYResult object upon completion of http request/response
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"getGravity" object:result];

		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {

			//http error

			//generic result with nil location, is checked from caller if there is a problem
			GVYResult *errorResult = [[GVYResult alloc] init];

			errorResult.location =  nil;
			errorResult.accel = [NSNumber numberWithDouble:0.0];

			NSLog(@"HTTP failure: %@", error);

			[subscriber sendError:error];
			[subscriber sendCompleted];

			//send notification with GVYResult object upon completion of http request/response
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"getGravity" object:errorResult];

		}];

		[op start];
		
		return nil;
	}];
}




@end
