//
//  Common.h
//
//  Created by Adam Miskiewicz on 6/2/11.
//  Copyright 2011 Bolster Labs, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NSDate+Misc.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

#define SWF(format, ...) [NSString stringWithFormat:format, __VA_ARGS__]
#define SBAS(string1, string2) [string1 stringByAppendingString:string2]
#define CGRTD(rect) CGRectCreateDictionaryRepresentation(rect)
#define CGPTD(pnt) CGPointCreateDictionaryRepresentation(pnt)
//
//#ifdef DEBUG_MODE
//    #define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#else
//    #define NSLog(__FORMAT__, ...)
//#endif

typedef void (^Block)();

//Color methods
UIColor* UIColorFromRGBVal(int rgbValue);
UIColor* UIColorFromRGBWithAlpha(int rgbValue, float alpha);
UIColor* UIColorFromRGBString(NSString* rgbString);
UIColor* UIColorFromRGBStringWithAlpha(NSString* rgbString, float alpha);
CGColorRef CGColorFromPercentage(CGColorRef initialColor, CGColorRef finalColor, CGFloat percentage);

//Drawing methods
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor);
CGRect rectFor1PxStroke(CGRect rect);
void draw1pxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);
void draw1PxDottedStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);
void drawRectangle(CGContextRef context, CGRect rect, CGPathDrawingMode drawMode);

typedef enum {
    RoundedRectTypeAllSides,
    RoundedRectTypeAllSidesDashed,
    RoundedRectTypeLeftSide,
    RoundedRectTypeRightSide,
    RoundedRectTypeTopSide,
    RoundedRectTypeBottomSide
} RoundedRectType;
void drawRoundedRect(CGContextRef context, CGRect rrect, CGFloat radius, CGPathDrawingMode drawMode, RoundedRectType rectType);

void drawCircle(CGContextRef context, CGPoint location, CGFloat radius, CGPathDrawingMode drawMode);

CGFontRef loadFont(NSString* fontName, NSString* fontType);

//Misc methods
NSArray* dictionaryToArray(NSDictionary* dict, SEL sel);
void listFonts();
UIColor* randomColor();
void notYetImplemented(void);
void showAlert(NSString *title, NSString *message);
NSDate* combineDateWithTime(NSDate *date, NSDate *time);
NSDate* removeTimeFromDate(NSDate *date);
NSString* getOrdinalSuffixForNumber(int number);
NSData* ensureImageIsNSData(id photoObject);
NSString* MD5StringOfString(NSString* inputStr);
NSString* timeIntervalToString(NSTimeInterval interval);
