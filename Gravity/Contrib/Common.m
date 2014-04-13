//
//  Common.m
//
//  Created by Adam Miskiewicz on 6/2/11.
//  Copyright 2011 Bolster Labs, LLC. All rights reserved.
//

#import "Common.h"

UIColor* UIColorFromRGBVal(int rgbValue) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

UIColor* UIColorFromRGBWithAlpha(int rgbValue, float alpha) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha];
}

UIColor* UIColorFromRGBString(NSString* rgbString)
{
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:rgbString];
    [scanner scanHexInt:&outVal];
    return UIColorFromRGBVal(outVal);
}

UIColor* UIColorFromRGBStringWithAlpha(NSString* rgbString, float alpha)
{
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:rgbString];
    [scanner scanHexInt:&outVal];
    return UIColorFromRGBWithAlpha(outVal, alpha);
}

CGColorRef CGColorFromPercentage(CGColorRef initialColor, CGColorRef finalColor, CGFloat percentage)
{
    const CGFloat *initialComponents = CGColorGetComponents(initialColor);
    const CGFloat *finalComponents = CGColorGetComponents(finalColor);

    CGFloat currentRed = ((finalComponents[0] - initialComponents[0]) * percentage) + initialComponents[0];
    CGFloat currentGreen = ((finalComponents[1] - initialComponents[1]) * percentage) + initialComponents[1];
    CGFloat currentBlue = ((finalComponents[2] - initialComponents[2]) * percentage) + initialComponents[2];
    CGFloat currentAlpha = ((finalComponents[3] - initialComponents[3]) * percentage) + initialComponents[3];

    CGFloat currentComponents[] = {currentRed, currentGreen, currentBlue, currentAlpha};

    CGColorRef currentColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), currentComponents);

    return currentColor;
}

CGRect rectFor1PxStroke(CGRect rect) {
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
}

void notYetImplemented(void) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Feature not yet implemented." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    return;
}

void showAlert(NSString *title, NSString *message) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    return;
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };

    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);

    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

void draw1pxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color) {
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);

    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

void draw1PxDottedStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color) {

    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);

    CGFloat dashPhase = 0.0f;
    CGFloat dashPattern[10] = { 1.0f, 2.0f };
    size_t dashCount = sizeof(dashPattern) / sizeof(CGFloat);

    CGContextSetLineDash(context, dashPhase, dashPattern, dashCount);

    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);

}

void drawRectangle(CGContextRef context, CGRect rect, CGPathDrawingMode drawMode) {
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, drawMode);
}

void drawRoundedRect(CGContextRef context, CGRect rrect, CGFloat radius, CGPathDrawingMode drawMode, RoundedRectType rectType) {
    if (drawMode == kCGPathFillStroke)
        rrect = CGRectInset(rrect, 1.0f, 1.0f);

    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);

    CGFloat leftTopRadius = (rectType == RoundedRectTypeAllSides | rectType == RoundedRectTypeLeftSide | rectType == RoundedRectTypeTopSide) ? radius : 0;
    CGFloat rightTopRadius = (rectType == RoundedRectTypeAllSides | rectType == RoundedRectTypeRightSide | rectType == RoundedRectTypeTopSide) ? radius : 0;
    CGFloat rightBottomRadius = (rectType == RoundedRectTypeAllSides | rectType == RoundedRectTypeRightSide | rectType == RoundedRectTypeBottomSide) ? radius : 0;
    CGFloat leftBottomRadius = (rectType == RoundedRectTypeAllSides | rectType == RoundedRectTypeLeftSide | rectType == RoundedRectTypeBottomSide) ? radius : 0;

    // Start at 1
	CGContextMoveToPoint(context, minx, midy);
	// Add an arc through 2 to 3
	CGContextAddArcToPoint(context, minx, miny, midx, miny, leftTopRadius); //leftTop
																			// Add an arc through 4 to 5
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, rightTopRadius); //rightTop
																			 // Add an arc through 6 to 7
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, rightBottomRadius); //rightBottom
																				// Add an arc through 8 to 9
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, leftBottomRadius); //leftBottom
																			   // Close the path
	CGContextClosePath(context);
	// Fill & stroke the path
    if (rectType == RoundedRectTypeAllSidesDashed) {
        CGFloat dash[2]={6,5};
        CGContextSetLineDash(context,0,dash,2);
    } else {
        CGFloat normal[1]={1};
        CGContextSetLineDash(context,0,normal,0);
    }

	CGContextDrawPath(context, drawMode);

    CGFloat normal[1]={1};
    CGContextSetLineDash(context,0,normal,0);
}

void drawCircle(CGContextRef context, CGPoint location, CGFloat radius, CGPathDrawingMode drawMode) {
    CGRect rect = CGRectMake(location.x, location.y, radius * 2, radius * 2);
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, drawMode);
}

CGFontRef loadFont(NSString* fontName, NSString* fontType) {
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:fontType];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
    CGFontRef cgGothicNo4 = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);

    return cgGothicNo4;
}

NSArray* dictionaryToArray(NSDictionary* dict, SEL sel)
{
    NSArray *keys = [[dict allKeys] sortedArrayUsingSelector:sel];

    NSMutableArray *arr = [[NSMutableArray alloc] init];

    for (id key in keys) {
        id obj = [dict objectForKey:key];
        [arr addObject:obj];
    }

    return arr;
}

NSDate* combineDateWithTime(NSDate *date, NSDate *time) {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    unsigned unitFlagsDate = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [gregorian components:unitFlagsDate fromDate:date];
    unsigned unitFlagsTime = NSHourCalendarUnit | NSMinuteCalendarUnit |  NSSecondCalendarUnit;
    NSDateComponents *timeComponents = [gregorian components:unitFlagsTime fromDate:time];

    [dateComponents setSecond:[timeComponents second]];
    [dateComponents setHour:[timeComponents hour]];
    [dateComponents setMinute:[timeComponents minute]];

    NSDate *combDate = [gregorian dateFromComponents:dateComponents];


    return combDate;
}

NSDate* removeTimeFromDate(NSDate *date) {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    unsigned unitFlagsDate = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [gregorian components:unitFlagsDate fromDate:date];

    [dateComponents setSecond:0];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];

    NSDate *combDate = [gregorian dateFromComponents:dateComponents];


    return combDate;
}

NSString* getOrdinalSuffixForNumber(int number) {
	NSArray *suffixLookup = [NSArray arrayWithObjects:@"th",@"st",@"nd",@"rd",@"th",@"th",@"th",@"th",@"th",@"th", nil];

	if (number % 100 >= 11 && number % 100 <= 13) {
		return [NSString stringWithFormat:@"%d%@", number, @"th"];
	}

	return [NSString stringWithFormat:@"%d%@", number, [suffixLookup objectAtIndex:(number % 10)]];
}

NSData* ensureImageIsNSData(id photoObject) {
    NSData *photoData = nil;

    if ([photoObject isKindOfClass:[NSData class]]) {
        photoData = photoObject;
    } else if (photoObject != nil & (NSNull*)photoObject != [NSNull null]) {
        photoData = UIImagePNGRepresentation((UIImage *)photoObject);
    }

    return photoData;
}

NSString* MD5StringOfString(NSString* inputStr)
{
	NSData* inputData = [inputStr dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char outputData[CC_MD5_DIGEST_LENGTH];
	CC_MD5([inputData bytes], (CC_LONG)[inputData length], outputData);

	NSMutableString* hashStr = [NSMutableString string];
	int i = 0;
	for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
		[hashStr appendFormat:@"%02x", outputData[i]];

	return hashStr;
}

NSString* timeIntervalToString(NSTimeInterval interval)
{
    long min = (long)interval / 60;    // divide two longs, truncates
    long sec = (long)interval % 60;    // remainder of long divide
    NSString* str = [[NSString alloc] initWithFormat:@"%02ld:%02ld", min, sec];
    return str;
}

void listFonts()
{
    // List all fonts on iPhone
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

UIColor* randomColor()
{
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}