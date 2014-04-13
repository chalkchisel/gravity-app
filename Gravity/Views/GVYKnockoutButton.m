//
//  GVYKnockoutButton.m
//  Gravity
//
//  Created by Adam Miskiewicz on 4/12/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import "GVYKnockoutButton.h"
#import "GVYKnockoutTextView.h"
#import "GVYAnimatedIconView.h"

@interface GVYKnockoutButton ()

@property (nonatomic, strong) GVYAnimatedIconView *loadingView;
@property (nonatomic, strong) GVYAnimatedIconView *iconView;
@property (nonatomic, strong) GVYKnockoutTextView *textView;

@end


@implementation GVYKnockoutButton

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code

		self.translatesAutoresizingMaskIntoConstraints = YES;

		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupButton
{
	self.iconView = ({
		GVYAnimatedIconView *v = [[GVYAnimatedIconView alloc] initWithAnimatedSequencePrefix:@"loc_located" frameCount:14 repeat:NO];
		v.backgroundColor = [UIColor clearColor];
		v.userInteractionEnabled = NO;
		v;
	});
	[self addSubview:self.iconView];

	self.loadingView = ({
		GVYAnimatedIconView *v = [[GVYAnimatedIconView alloc] initWithAnimatedSequencePrefix:@"loc_loading" frameCount:15 repeat:YES];
		v.backgroundColor = [UIColor clearColor];
		v.alpha = 0.0f;
		v.userInteractionEnabled = NO;
		v;
	});
	[self addSubview:self.loadingView];

	self.textView = ({
		GVYKnockoutTextView *v = [[GVYKnockoutTextView alloc] initWithText:[self titleForState:UIControlStateNormal]];
		v.backgroundColor = [UIColor clearColor];
		v.userInteractionEnabled = NO;
		v;
	});

	[self addSubview:self.textView];
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	[self.titleLabel removeFromSuperview];

	CGRect bounds = self.bounds;

	//Loading View
	CGRect loadingViewFrame = CGRectMake(0, 0, 67, bounds.size.height);
	self.loadingView.frame = loadingViewFrame;

	//Icon View
	CGRect iconViewFrame = CGRectMake(0, 0, 67, bounds.size.height);
	self.iconView.frame = iconViewFrame;

	//Text View
	CGRect textViewFrame = CGRectMake(71, 0, bounds.size.width - 71, bounds.size.height);
	self.textView.frame = textViewFrame;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
	[super setTitle:title forState:state];

	[self.textView setText:title];
}

- (void)startLoading
{
	self.iconView.alpha = 0.0f;
	self.loadingView.alpha = 1.0f;
	[self.loadingView startAnimation];
}

- (void)stopLoading
{
	[UIView animateWithDuration:.5f animations:^{
		self.loadingView.alpha = 0.0f;
		self.iconView.alpha = 1.f;
	} completion:^(BOOL finished) {
		[self.loadingView stopAnimation];
	}];
}

- (void)animateIconView
{
	[self.iconView startAnimation];
}

@end
