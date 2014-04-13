//
// Created by Adam Miskiewicz on 12/16/13.
// Copyright (c) 2013 WeGo. All rights reserved.
//

#import "BOLAnimation.h"


@interface BOLAnimation ()

@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, assign) NSTimeInterval delay;
@property(nonatomic, assign) CGFloat damping;
@property(nonatomic, assign) CGFloat springVelocity;
@property(nonatomic, assign) UIViewAnimationOptions options;
@property(nonatomic, strong) Block animations;
@property(nonatomic, assign) BOOL isSimultaneous;
@property(nonatomic, assign) BOOL useSpringDamping;

@end


@implementation BOLAnimation

+ (BOLAnimation*)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(Block)animations
{
    return [[BOLAnimation alloc] initWithDuration:duration delay:delay options:options animations:animations simultaneous:NO];
}

+ (BOLAnimation*)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)damping initialSpringVelocity:(CGFloat)springVelocity options:(UIViewAnimationOptions)options animations:(Block)animations
{
    return [[BOLAnimation alloc] initWithDuration:duration delay:delay usingSpringWithDamping:damping initialSpringVelocity:springVelocity options:options animations:animations simultaneous:NO];
}

+ (BOLAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(Block)animations simultaneous:(BOOL)isSimultaneous
{
    return [[BOLAnimation alloc] initWithDuration:duration delay:delay options:options animations:animations simultaneous:isSimultaneous];
}

+ (BOLAnimation*)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)damping initialSpringVelocity:(CGFloat)springVelocity options:(UIViewAnimationOptions)options animations:(Block)animations simultaneous:(BOOL)isSimultaneous
{
    return [[BOLAnimation alloc] initWithDuration:duration delay:delay usingSpringWithDamping:damping initialSpringVelocity:springVelocity options:options animations:animations simultaneous:isSimultaneous];
}

+ (RACSignal*)performAnimations:(NSArray*)animations
{
    // Make sure signal is delivered on the main thread because that's where animations are performed
    return [[[animations.rac_sequence.signal deliverOn:[RACScheduler mainThreadScheduler]] map:^id(BOLAnimation *animation) {
        return [animation startAnimation];
    }] concat];
}

- (id)initWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(Block)animations simultaneous:(BOOL)isSimultaneous
{
    self = [self initWithDuration:duration delay:delay usingSpringWithDamping:0.0f initialSpringVelocity:0.0f options:options animations:animations simultaneous:(BOOL)isSimultaneous];
    if(self) {
        self.useSpringDamping = NO;
    }
    return self;
}

- (id)initWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)damping initialSpringVelocity:(CGFloat)springVelocity options:(UIViewAnimationOptions)options animations:(Block)animations simultaneous:(BOOL)isSimultaneous
{
    self = [super init];
    if(self) {
        self.duration = duration;
        self.delay = delay;
        self.damping = damping;
        self.springVelocity = springVelocity;
        self.options = options;
        self.animations = animations;
        self.isSimultaneous = isSimultaneous;
        self.useSpringDamping = YES;
    }
    return self;
}

- (RACSignal*)startAnimation
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);

        void (^sendComplete)(BOOL) = ^(BOOL finished) {
            [subscriber sendNext:self];
            [subscriber sendCompleted];
        };

        void (^completionBlock)(BOOL) = nil;

        if (self.isSimultaneous) {
            sendComplete(YES);
        } else {
            completionBlock = sendComplete;
        }

        if (self.useSpringDamping) {
            [UIView animateWithDuration:self.duration delay:self.delay usingSpringWithDamping:self.damping initialSpringVelocity:self.springVelocity options:self.options animations:self.animations completion:completionBlock];
        } else {
            [UIView animateWithDuration:self.duration delay:self.delay options:self.options animations:self.animations completion:completionBlock];
        }

        return nil;
    }];
}

@end