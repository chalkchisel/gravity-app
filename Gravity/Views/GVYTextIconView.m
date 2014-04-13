//
//  GVYTextIconView.m
//  Gravity
//
//  Created by Adam Miskiewicz on 4/13/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import "GVYTextIconView.h"
#import "BOLAnimation.h"

@interface GVYTextIconView ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *lbl;

@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) BOOL visible;

@property (nonatomic, strong) MASConstraint *iconCenterConstraint;
@property (nonatomic, strong) MASConstraint *lblCenterConstraint;

@end

@implementation GVYTextIconView

- (id)initWithIcon:(UIImage*)image text:(NSString*)text offset:(CGFloat)offset
{
    self = [super init];
    if (self) {
        // Initialization code

		self.iconView = [[UIImageView alloc] initWithImage:image];

		[self addSubview:self.iconView];

		self.lbl = [[UILabel alloc] init];

		self.lbl.text = text;
		self.lbl.font = [UIFont fontWithName:@"EurostileRegular" size:39.f];
		self.lbl.textColor = [UIColor whiteColor];
		self.lbl.textAlignment = NSTextAlignmentRight;

		[self addSubview:self.lbl];

		self.clipsToBounds = YES;

		self.offset = offset;
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

- (void)setTextForLabel:(NSString*)text
{
	self.lbl.text = text;
}

- (void)updateConstraints
{
	[super updateConstraints];

	[self.iconView updateConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(@0);

		self.iconCenterConstraint = make.centerY.equalTo(self).with.offset(self.offset);

		make.width.equalTo(@(self.iconView.image.size.width));
		make.height.equalTo(@(self.iconView.image.size.height));
	}];

	[self.lbl updateConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.iconView.right).with.offset(20);
		make.right.equalTo(self.right);

		self.lblCenterConstraint = make.centerY.equalTo(self).with.offset(self.offset);

		make.height.equalTo(@40);
	}];
}

- (BOLAnimation*)animateInAnimation:(BOOL)isSimultaneous
{
	return [BOLAnimation animationWithDuration:.5f delay:0.0f options:0 animations:^{
		[self.iconCenterConstraint uninstall];
		[self.lblCenterConstraint uninstall];

		[self.iconView updateConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self).with.offset(0);
		}];

		[self.lbl updateConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self).with.offset(0);
		}];
		
		[self layoutIfNeeded];
	} simultaneous:isSimultaneous];
}

- (BOLAnimation*)animateOutAnimation:(BOOL)isSimultaneous
{
	return [BOLAnimation animationWithDuration:.5f delay:0.0f options:0 animations:^{
		[self.iconCenterConstraint uninstall];
		[self.lblCenterConstraint uninstall];

		[self.iconView updateConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self).with.offset(self.offset);
		}];

		[self.lbl updateConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self).with.offset(self.offset);
		}];

		[self layoutIfNeeded];
	} simultaneous:isSimultaneous];
}

@end
