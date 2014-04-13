//
// Created by Adam Miskiewicz on 12/16/13.
// Copyright (c) 2013 WeGo. All rights reserved.
//

@interface BOLAnimation : NSObject

@property(nonatomic, readonly, assign) NSTimeInterval duration;
@property(nonatomic, readonly, assign) NSTimeInterval delay;
@property(nonatomic, readonly, assign) CGFloat damping;
@property(nonatomic, readonly, assign) CGFloat springVelocity;
@property(nonatomic, readonly, assign) UIViewAnimationOptions options;
@property(nonatomic, readonly, assign) BOOL isSimultaneous;
@property(nonatomic, readonly, strong) Block animations;

- (id)initWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(Block)animations simultaneous:(BOOL)isSimultaneous;
- (id)initWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)damping initialSpringVelocity:(CGFloat)springVelocity options:(UIViewAnimationOptions)options animations:(Block)animations simultaneous:(BOOL)isSimultaneous;

- (RACSignal *)startAnimation;

+ (BOLAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(Block)animations;
+ (BOLAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)damping initialSpringVelocity:(CGFloat)springVelocity options:(UIViewAnimationOptions)options animations:(Block)animations;

+ (BOLAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(Block)animations simultaneous:(BOOL)isSimultaneous;
+ (BOLAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)damping initialSpringVelocity:(CGFloat)springVelocity options:(UIViewAnimationOptions)options animations:(Block)animations simultaneous:(BOOL)isSimultaneous;

+ (RACSignal *)performAnimations:(NSArray *)animations;

@end