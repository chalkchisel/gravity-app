//
//  GVYAnimatedIconView.m
//  Gravity
//
//  Created by Adam Miskiewicz on 4/12/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import "GVYAnimatedIconView.h"

@interface GVYAnimatedIconView ()

@property (nonatomic, strong) NSString *sequencePrefix;
@property (nonatomic, assign) NSInteger frameCount;
@property (nonatomic, assign) BOOL repeat;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GVYAnimatedIconView

- (id)initWithAnimatedSequencePrefix:(NSString*)sequencePrefix frameCount:(NSInteger)frameCount repeat:(BOOL)repeat
{
    self = [super init];
    if (self) {
		self.sequencePrefix = sequencePrefix;
		self.frameCount = frameCount;

		self.imageView = ({
			UIImageView *imageView = [[UIImageView alloc] init];
			imageView.image = [UIImage imageNamed:SWF(@"%@_00", sequencePrefix)];
			imageView;
		});
		[self addSubview:self.imageView];

		self.translatesAutoresizingMaskIntoConstraints = NO;

		self.repeat = repeat;

		[self setupAnimation];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
	[super layoutSubviews];

	self.imageView.frame = self.bounds;
}

- (void)setupAnimation
{
	NSMutableArray *images = [NSMutableArray new];

	for(NSInteger i = 0; i < self.frameCount; i++) {
		UIImage *image = [UIImage imageNamed:SWF(@"%@_%02ld", self.sequencePrefix, (long)i)];
		if (image) {
			[images addObject:image];
		}
	}

	self.imageView.animationImages = images;
	self.imageView.animationDuration = self.frameCount / 29.97f;
	self.imageView.animationRepeatCount = self.repeat ? 0 : 1;
}

- (void)startAnimation
{
	self.imageView.image = [UIImage imageNamed:SWF(@"%@_%2ld", self.sequencePrefix, (long)self.frameCount - 1)];
	[self setupAnimation];
	[self.imageView startAnimating];
}

- (void)stopAnimation
{
	[self.imageView stopAnimating];
}

@end
