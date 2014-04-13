//
//  GVYTextIconView.h
//  Gravity
//
//  Created by Adam Miskiewicz on 4/13/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BOLAnimation;

@interface GVYTextIconView : UIView

- (id)initWithIcon:(UIImage*)image text:(NSString*)text offset:(CGFloat)offset;

- (BOLAnimation*)animateInAnimation:(BOOL)isSimultaneous;
- (BOLAnimation*)animateOutAnimation:(BOOL)isSimultaneous;

- (void)setTextForLabel:(NSString*)text;

@end
