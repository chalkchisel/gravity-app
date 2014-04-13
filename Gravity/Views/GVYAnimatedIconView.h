//
//  GVYAnimatedIconView.h
//  Gravity
//
//  Created by Adam Miskiewicz on 4/12/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVYAnimatedIconView : UIView

- (id)initWithAnimatedSequencePrefix:(NSString*)sequencePrefix frameCount:(NSInteger)frameCount repeat:(BOOL)repeat;

- (void)startAnimation;
- (void)stopAnimation;

@end
