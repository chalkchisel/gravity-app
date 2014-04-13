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
#import "GVYHTTPCaller.h"
#import "GVYAnimatedIconView.h"

#import "BOLAnimation.h"

@interface GVYMainViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *locationStr;

// Views
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) UILabel *introTitleLabel;
@property (nonatomic, strong) UILabel *introTextLabel;

@property (nonatomic, strong) GVYKnockoutButton *findMeButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) GVYTextIconView *gravityValueView;
@property (nonatomic, strong) GVYTextIconView *altitudeValueView;

@property (nonatomic, strong) GVYAnimatedIconView *waveView;

@property (nonatomic, strong) GVYAnimatedIconView *smallSpaceManView;
@property (nonatomic, strong) GVYAnimatedIconView *spaceManView;

@property (nonatomic, strong) UIView *lighterHeavierViewContainer;

@property (nonatomic, strong) UILabel *lighterHeavierLabel;
@property (nonatomic, strong) UIImageView *lighterHeavierIcon;

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

	self.locationManager = [[CLLocationManager alloc] init];

	self.locationManager.delegate = self;
	self.locationManager.distanceFilter = kCLDistanceFilterNone;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

	self.animatableConstraints = [NSMutableDictionary new];

	self.backgroundImageView = ({
		UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
		imv;
	});
	[self.view addSubview:self.backgroundImageView];

	self.smallSpaceManView = ({
		GVYAnimatedIconView *v = [[GVYAnimatedIconView alloc] initWithAnimatedSequencePrefix:@"small_Astro" frameCount:56 repeat:NO];
		v.userInteractionEnabled = NO;
		v;
	});
	[self.view addSubview:self.smallSpaceManView];

	self.waveView = ({
		GVYAnimatedIconView *v = [[GVYAnimatedIconView alloc] initWithAnimatedSequencePrefix:@"wave" frameCount:10 repeat:YES];

		v;
	});
	[self.view addSubview:self.waveView];
	[self.waveView startAnimation];

	self.logoView = ({
		UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
		imv.userInteractionEnabled = YES;
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

	self.lighterHeavierViewContainer = ({
		UIView *v = [[UIView alloc] init];
		v.alpha = 0.0f;
		v;
	});
	[self.view addSubview:self.lighterHeavierViewContainer];

	self.lighterHeavierIcon = ({
		UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon--heavy"]];

		v;
	});
	[self.lighterHeavierViewContainer addSubview:self.lighterHeavierIcon];

	self.lighterHeavierLabel = ({
		UILabel *l = [[UILabel alloc] init];
		l.text = @"You're .007% lighter here.";
		l.font = [UIFont fontWithName:@"EurostileRegular" size:18.f];
		l.textColor = [UIColor whiteColor];
		l;
	});
	[self.lighterHeavierViewContainer addSubview:self.lighterHeavierLabel];

	self.spaceManView = ({
		GVYAnimatedIconView *v = [[GVYAnimatedIconView alloc] initWithAnimatedSequencePrefix:@"Astro" frameCount:31 repeat:NO];
		v.userInteractionEnabled = NO;
		v;
	});
	[self.view addSubview:self.spaceManView];

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

		[self.locationManager startUpdatingLocation];

		return [RACSignal empty];
	}];

	UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateToHome)];
	tapG.numberOfTouchesRequired = 1;
	[self.logoView addGestureRecognizer:tapG];
}

#pragma mark - location

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);

	[self.locationManager stopUpdatingLocation];

	if (newLocation.coordinate.latitude != oldLocation.coordinate.latitude && newLocation.coordinate.longitude != oldLocation.coordinate.longitude) {
		CLGeocoder *geocoder = [[CLGeocoder alloc] init];

		[geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
			self.locationStr = ((CLPlacemark*)placemarks[0]).locality;
			NSString *gravityStr = SWF(@"lat=%f&long=%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);

			GVYHTTPCaller *httpCaller = [[GVYHTTPCaller alloc] init];

			__block GVYResult *result = nil;

			[[httpCaller getGravity:gravityStr] subscribeNext:^(GVYResult* x) {
				result = x;
			} completed:^{
				[self.findMeButton stopLoading];
				[self.findMeButton animateIconView];

				float ges = [result.accel floatValue] / 9.80665f;

				[self.gravityValueView setTextForLabel:SWF(@"%fg", ges)];
				[self.altitudeValueView setTextForLabel:SWF(@"%2.fm", newLocation.altitude)];

				if (ges > 1.f) {
					self.lighterHeavierIcon.image = [UIImage imageNamed:@"icon--heavy"];
					self.lighterHeavierLabel.text = SWF(@"You're %0.4f%% heavier here.", fabs(1.f - ges));
				} else if (ges < 1.f) {
					self.lighterHeavierIcon.image = [UIImage imageNamed:@"icon--light"];
					self.lighterHeavierLabel.text = SWF(@"You're %0.4f%% lighter here.", 1.f - ges);
				}

				[self animateToDataDisplay];

				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self.spaceManView startAnimation];
				});

				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[self.smallSpaceManView startAnimation];
				});
			}];
		}];
	} else {
		[self.findMeButton stopLoading];
	}
}

#pragma mark - Animate To Date Display

- (void)animateToDataDisplay
{
//	NSString *locationStr = @"BALTIMORE, MD";

	[self.findMeButton setTitle:self.locationStr forState:UIControlStateNormal];

	NSArray *firstAnimations = ({
		BOLAnimation *buttonAnimation = [BOLAnimation animationWithDuration:.5f delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
			[self.findMeButton updateConstraints:^(MASConstraintMaker *make) {
				MASConstraint *topConstraint = self.animatableConstraints[@"button_top"];
				[topConstraint uninstall];
				UIView *bottomLayoutGuide = (id)self.bottomLayoutGuide;
				self.animatableConstraints[@"button_top"] = make.bottom.equalTo(bottomLayoutGuide.bottom).with.offset(-10);
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
				self.animatableConstraints[@"line_width"] = ((MASConstraint*)self.animatableConstraints[@"line_width"]).equalTo(@282);
			}];
			[self.view layoutIfNeeded];
		}];

		BOLAnimation *topTextAnimation = [self.gravityValueView animateInAnimation:YES];

		BOLAnimation *bottomTextAnimation = [self.altitudeValueView animateInAnimation:NO];

		BOLAnimation *lighterHeavierAnimation = [BOLAnimation animationWithDuration:.5f delay:0.f options:0 animations:^{
			self.lighterHeavierViewContainer.alpha = 1.0f;
		}];

		@[animateLine, topTextAnimation, bottomTextAnimation, lighterHeavierAnimation];
	});

	[[BOLAnimation performAnimations:firstAnimations] subscribeCompleted:^{
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[[BOLAnimation performAnimations:afterButtonAnimations] subscribeCompleted:^{

			}];
		});
	}];
}

- (void)animateToHome
{
	[self.findMeButton setTitle:@"FIND ME" forState:UIControlStateNormal];

	NSArray *firstAnimations = ({
		BOLAnimation *buttonAnimation = [BOLAnimation animationWithDuration:.5f delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
			[self.findMeButton updateConstraints:^(MASConstraintMaker *make) {
				MASConstraint *topConstraint = self.animatableConstraints[@"button_top"];
				[topConstraint uninstall];
				self.animatableConstraints[@"button_top"] = make.top.equalTo(@294);
			}];

			[self.view layoutIfNeeded];
		} simultaneous:YES];

		BOLAnimation *fadeTextAnimation = [BOLAnimation animationWithDuration:.5f delay:0.0f options:0 animations:^{
			self.introTitleLabel.alpha = 1.0f;
			self.introTextLabel.alpha = 1.0f;
		} simultaneous:NO];

		@[ buttonAnimation, fadeTextAnimation];
	});

	NSArray *afterButtonAnimations = ({
		BOLAnimation *animateLine = [BOLAnimation animationWithDuration:.5f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:.5f options:0 animations:^{
			[self.lineView updateConstraints:^(MASConstraintMaker *make) {
				self.animatableConstraints[@"line_width"] = ((MASConstraint*)self.animatableConstraints[@"line_width"]).equalTo(@0);
			}];
			[self.view layoutIfNeeded];
		}];

		BOLAnimation *lighterHeavierAnimation = [BOLAnimation animationWithDuration:.5f delay:0.f options:0 animations:^{
			self.lighterHeavierViewContainer.alpha = 0.0f;
		} simultaneous:NO];

		BOLAnimation *topTextAnimation = [self.gravityValueView animateOutAnimation:YES];

		BOLAnimation *bottomTextAnimation = [self.altitudeValueView animateOutAnimation:NO];

		@[lighterHeavierAnimation, topTextAnimation, bottomTextAnimation, animateLine];
	});

	[[BOLAnimation performAnimations:afterButtonAnimations] subscribeCompleted:^{
		[[BOLAnimation performAnimations:firstAnimations] subscribeCompleted:^{

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

	[self.smallSpaceManView updateConstraints:^(MASConstraintMaker *make) {
		UIView *topLayoutGuide = (id)self.topLayoutGuide;
		UIView *bottomLayoutGuide = (id)self.bottomLayoutGuide;

		make.top.equalTo(topLayoutGuide.bottom);
		make.bottom.equalTo(bottomLayoutGuide.top);

		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
	}];

	[self.waveView updateConstraints:^(MASConstraintMaker *make) {
		UIView *bottomLayoutGuide = (id)self.bottomLayoutGuide;

		make.bottom.equalTo(bottomLayoutGuide.top).with.offset(-140);
		make.centerX.equalTo(self.view);

		make.width.equalTo(@320);
		make.height.equalTo(@187.5);
	}];

	[self.spaceManView updateConstraints:^(MASConstraintMaker *make) {
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

	[self.lighterHeavierViewContainer updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.altitudeValueView.bottom);

		make.centerX.equalTo(self.view);

		make.width.equalTo(@282);
		make.height.equalTo(@45);
	}];

	[self.lighterHeavierIcon updateConstraints:^(MASConstraintMaker *make) {

		make.centerY.equalTo(self.lighterHeavierViewContainer);
		make.width.equalTo(@45);
		make.height.equalTo(@45);

		make.left.equalTo(@0);
	}];

	[self.lighterHeavierLabel updateConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self.lighterHeavierViewContainer);

		make.right.equalTo(@0);
		make.left.equalTo(self.lighterHeavierIcon.right).with.offset(5.f);

		make.height.equalTo(@45);
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
