//
//  GVYViewController.m
//  Gravity
//
//  Created by Adam Miskiewicz on 4/12/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import "GVYMainViewController.h"
#import "GVYKnockoutButton.h"
#import "GVYTextIconView.h"

#import "BOLAnimation.h"

@interface GVYMainViewController ()

// Views
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) UILabel *introTitleLabel;
@property (nonatomic, strong) UILabel *introTextLabel;

@property (nonatomic, strong) GVYKnockoutButton *findMeButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) GVYTextIconView *gravityValueView;
@property (nonatomic, strong) GVYTextIconView *altitudeValueView;

// Constraints
@property (nonatomic, strong) NSMutableDictionary *animatableConstraints;

@end

@implementation GVYMainViewController

- (id)init
{
	self = [super init];
	if (self) {

	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	self.animatableConstraints = [NSMutableDictionary new];

	self.backgroundImageView = ({
		UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
		imv;
	});
	[self.view addSubview:self.backgroundImageView];

	self.logoView = ({
		UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
		imv;
	});
	[self.view addSubview:self.logoView];

	self.introTitleLabel = ({
		UILabel *lbl = [[UILabel alloc] init];
		[lbl setText:@"Welcome to GRAVITY."];
		lbl.font = [UIFont fontWithName:@"GothamRounded-Medium" size:12.f];
		lbl.textColor = [UIColor whiteColor];
		lbl;
	});
	[self.view addSubview:self.introTitleLabel];

	self.introTextLabel = ({
		NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
		paragraphStyle.lineSpacing = 7.f;
		paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
		NSDictionary *attrs = @{
								NSFontAttributeName: [UIFont fontWithName:@"GothamRounded-Book" size:12.f],
								NSParagraphStyleAttributeName: paragraphStyle,
								NSForegroundColorAttributeName: [UIColor whiteColor]
								};
		NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Donec sed odio dui. Maecenas sed diam eget risus varius blandit sit amet non magna." attributes:attrs];
		UILabel *lbl = [[UILabel alloc] init];
		lbl.numberOfLines = 0;
		[lbl setAttributedText:text];
		lbl;
	});
	[self.view addSubview:self.introTextLabel];

	self.findMeButton = ({
		GVYKnockoutButton *button = [GVYKnockoutButton new];
		[button setTitle:@"FIND ME" forState:UIControlStateNormal];
		[button setupButton];
		button;
	});
	[self.view addSubview:self.findMeButton];


	self.lineView = ({
		UIView *v = [[UIView alloc] init];
		v.backgroundColor = [UIColor whiteColor];
		v;
	});
	[self.view addSubview:self.lineView];

	self.gravityValueView = ({
		GVYTextIconView *v = [[GVYTextIconView alloc] initWithIcon:[UIImage imageNamed:@"icon--gravity"] text:@"0.9998g" offset:65.f];

		v;
	});
	[self.view addSubview:self.gravityValueView];

	self.altitudeValueView = ({
		GVYTextIconView *v = [[GVYTextIconView alloc] initWithIcon:[UIImage imageNamed:@"icon--altitude"] text:@"2754m" offset:-65.f];

		v;
	});
	[self.view addSubview:self.altitudeValueView];

	[self setupEventHandlers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events

- (void)setupEventHandlers
{
	self.findMeButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(GVYKnockoutButton *btn) {
		[self.findMeButton startLoading];

		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.findMeButton stopLoading];
			[self.findMeButton animateIconView];
			[self animateToDataDisplay];
		});

		return [RACSignal empty];
	}];
}

#pragma mark - Animate To Date Display

- (void)animateToDataDisplay
{
	NSString *locationStr = @"BALTIMORE, MD";

	[self.findMeButton setTitle:locationStr forState:UIControlStateNormal];

	NSArray *firstAnimations = ({
		BOLAnimation *buttonAnimation = [BOLAnimation animationWithDuration:.5f delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
			[self.findMeButton updateConstraints:^(MASConstraintMaker *make) {
				MASConstraint *topConstraint = self.animatableConstraints[@"button_top"];
				[topConstraint uninstall];
				UIView *bottomLayoutGuide = (id)self.bottomLayoutGuide;
				make.bottom.equalTo(bottomLayoutGuide.bottom).with.offset(-10);
			}];

			[self.view layoutIfNeeded];
		} simultaneous:YES];

		BOLAnimation *fadeTextAnimation = [BOLAnimation animationWithDuration:.5f delay:0.0f options:0 animations:^{
			self.introTitleLabel.alpha = 0.0f;
			self.introTextLabel.alpha = 0.0f;
		} simultaneous:NO];

		@[ buttonAnimation, fadeTextAnimation];
	});

	NSArray *afterButtonAnimations = ({
		BOLAnimation *animateLine = [BOLAnimation animationWithDuration:.5f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:.5f options:0 animations:^{
			[self.lineView updateConstraints:^(MASConstraintMaker *make) {
				((MASConstraint*)self.animatableConstraints[@"line_width"]).equalTo(@282);
			}];
			[self.view layoutIfNeeded];
		}];

		BOLAnimation *topTextAnimation = [self.gravityValueView animateInAnimation:YES];

		BOLAnimation *bottomTextAnimation = [self.altitudeValueView animateInAnimation:YES];

		@[animateLine, topTextAnimation, bottomTextAnimation];
	});

	[[BOLAnimation performAnimations:firstAnimations] subscribeCompleted:^{
		[[BOLAnimation performAnimations:afterButtonAnimations] subscribeCompleted:^{

		}];
	}];
}

#pragma mark - Constraints

- (void)updateViewConstraints
{
	[super updateViewConstraints];

	[self.backgroundImageView updateConstraints:^(MASConstraintMaker *make) {
		UIView *topLayoutGuide = (id)self.topLayoutGuide;
		UIView *bottomLayoutGuide = (id)self.bottomLayoutGuide;

		make.top.equalTo(topLayoutGuide.bottom);
		make.bottom.equalTo(bottomLayoutGuide.top);

		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
	}];

	[self.logoView updateConstraints:^(MASConstraintMaker *make) {
		UIView *topLayoutGuide = (id)self.topLayoutGuide;

		make.top.equalTo(topLayoutGuide.bottom).with.offset(48);

		make.centerX.equalTo(self.view);
		make.height.equalTo(@(45));
	}];

	[self.introTitleLabel updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.logoView.bottom).with.offset(54);

		make.centerX.equalTo(self.view);

		make.width.equalTo(@282);
	}];

	[self.introTextLabel updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.introTitleLabel.bottom).with.offset(15);

		make.centerX.equalTo(self.view);

		make.width.equalTo(@282);
	}];

	[self.findMeButton updateConstraints:^(MASConstraintMaker *make) {
		self.animatableConstraints[@"button_top"] = make.top.equalTo(@294);

		make.centerX.equalTo(self.view);

		make.width.equalTo(@282);
		make.height.equalTo(@66);
	}];

	//Data view
	[self.lineView updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.logoView.bottom).with.offset(98);

		make.centerX.equalTo(self.view);

		self.animatableConstraints[@"line_width"] = make.width.equalTo(@0);
		make.height.equalTo(@1);
	}];

	[self.gravityValueView updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.lineView.top);

		make.centerX.equalTo(self.view);

		make.width.equalTo(@282);
		make.height.equalTo(@65);
	}];

	[self.altitudeValueView updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.lineView.bottom);
		make.centerX.equalTo(self.view);

		make.width.equalTo(@282);
		make.height.equalTo(@65);
	}];
}

#pragma mark - Misc

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
