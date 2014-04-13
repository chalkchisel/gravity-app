//
//  GVYKnockoutTextView.m
//  Gravity
//
//  Created by Adam Miskiewicz on 4/12/14.
//  Copyright (c) 2014 Bolster. All rights reserved.
//

#import "GVYKnockoutTextView.h"

@interface GVYKnockoutTextView ()

@property (nonatomic, strong) NSString *labelText;

@property (nonatomic, assign) CGSize sizeForText;
@property (nonatomic, assign) CGFloat fontSizeForText;

@end

@implementation GVYKnockoutTextView

- (id)initWithText:(NSString*)text
{
    self = [super init];
    if (self) {
        // Initialization code

		self.translatesAutoresizingMaskIntoConstraints = NO;

		[self setText:text];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	[[UIColor whiteColor] setFill];
	UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
	[path fill];

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context); {
		CGContextSetBlendMode(context, kCGBlendModeDestinationOut);

		CGFloat fontSize;
		CGSize textSize = [self.labelText sizeWithFont:[UIFont fontWithName:@"GothamRounded-Book" size:30.f] minFontSize:15.f actualFontSize:&fontSize forWidth:CGRectInset(self.bounds, 10, 10).size.width lineBreakMode:UILineBreakModeTailTruncation];

		CGPoint drawPoint = CGPointMake((self.bounds.size.width - textSize.width) / 2.f, (self.bounds.size.height - fontSize) / 2.f);

		[self.labelText drawAtPoint:drawPoint withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"GothamRounded-Book" size:fontSize]}];
	} CGContextRestoreGState(context);
}

- (void)setText:(NSString*)text
{
	self.labelText = text;

	UIView *whiteView = [[UIView alloc] initWithFrame:self.bounds];
	whiteView.backgroundColor = [UIColor whiteColor];
	whiteView.alpha = 0.0f;
	[self addSubview:whiteView];

	[UIView animateWithDuration:0.5f animations:^{
		whiteView.alpha = 1.0;
	} completion:^(BOOL finished) {
		[self setNeedsDisplay];
		[UIView animateWithDuration:0.5f animations:^{
			whiteView.alpha = 0.0f;
		} completion:^(BOOL finished) {
			[whiteView removeFromSuperview];
			[self setNeedsDisplay];
		}];
	}];
}

@end
