//
//  HTACircularProgressView.m
//  HTACircularProgressView
//
//  Created by Malolan on 4/1/14.
//  Copyright (c) 2014 Haptrix. All rights reserved.
//

#import "HTACircularProgressView.h"

@interface HTACircularLayer : CAShapeLayer

@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) CGFloat strokeWidth;
@property (assign, nonatomic) CGPoint center;

- (instancetype)initWithCenter:(CGPoint)aCenter;

@end

@implementation HTACircularLayer

- (instancetype)initWithCenter:(CGPoint)aCenter {
	self = [super init];
	if (self) {
		self.center = aCenter;
	}
	return self;
}

- (void)drawInContext:(CGContextRef)ctx {
	UIBezierPath *circularPath = [UIBezierPath bezierPathWithArcCenter:self.center
	                                                            radius:self.radius
	                                                        startAngle:-M_PI / 2.0
	                                                          endAngle:(3 * M_PI) / 2.0
	                                                         clockwise:YES];
	self.path = circularPath.CGPath;
	self.fillColor = [[UIColor clearColor] CGColor];
	self.lineWidth = self.strokeWidth;
}

@end

@interface HTACircularProgressView ()

@property (strong, nonatomic) HTACircularLayer *trackCircleLayer;
@property (strong, nonatomic) HTACircularLayer *progressCircleLayer;

@property (assign, nonatomic) CGFloat trackRadius;
@property (assign, nonatomic) CGFloat progressRadius;

@property (strong, nonatomic) CABasicAnimation *strokeEndAnimation;

@end

@implementation HTACircularProgressView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_trackRadius = MIN(CGRectGetWidth(self.bounds) / 2.0f, CGRectGetHeight(self.bounds) / 2.0f);
		_progress    = 0.0f;

		[self initalizeLayers];
		[self setupAnimation];
	}
	return self;
}

/**
 *  Initalize the defualt UIAppearance
 */
+ (void)initialize {
	if (self == [HTACircularProgressView class]) {
		HTACircularProgressView *apperanceProxy = [HTACircularProgressView appearance];
		[apperanceProxy setTrackTintColor:[UIColor colorWithRed:0.000 green:0.200 blue:1.000 alpha:1.000]];
		[apperanceProxy setProgressTintColor:[UIColor colorWithRed:0.000 green:0.200 blue:1.000 alpha:1.000]];
		[apperanceProxy setTrackStrokeWidthRatio:0.1f];
		[apperanceProxy setProgressStrokeWidthRatio:0.15f];
	}
}

#pragma mark - UIAppearance setter methods

- (void)setProgressTintColor:(UIColor *)progressTintColor {
	if (_progressTintColor != progressTintColor) {
		_progressTintColor = progressTintColor;
		self.progressCircleLayer.strokeColor = [self.progressTintColor CGColor];
		[self.progressCircleLayer setNeedsDisplay];
	}
}

- (void)setProgressStrokeWidthRatio:(CGFloat)progressStrokeWidthRatio {
	if (_progressStrokeWidthRatio != progressStrokeWidthRatio) {
		_progressStrokeWidthRatio = progressStrokeWidthRatio;
		self.progressCircleLayer.strokeWidth = self.progressStrokeWidthRatio * self.trackRadius;
		self.progressCircleLayer.radius = ceil(self.trackCircleLayer.radius - ((self.trackCircleLayer.strokeWidth + self.progressCircleLayer.strokeWidth) / 2.0f));
		[self.progressCircleLayer setNeedsDisplay];
	}
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
	if (_trackTintColor != trackTintColor) {
		_trackTintColor = trackTintColor;
		self.trackCircleLayer.strokeColor = [self.trackTintColor CGColor];
		[self.trackCircleLayer setNeedsDisplay];
	}
}

- (void)setTrackStrokeWidthRatio:(CGFloat)trackStrokeWidthRatio {
	if (_trackStrokeWidthRatio != trackStrokeWidthRatio) {
		_trackStrokeWidthRatio = trackStrokeWidthRatio;
		self.trackCircleLayer.strokeWidth = self.trackStrokeWidthRatio * self.trackRadius;
		self.trackCircleLayer.radius = self.trackCircleLayer.radius - (self.trackCircleLayer.strokeWidth / 2.0f);
		[self setProgressStrokeWidthRatio:self.progressStrokeWidthRatio];
		[self.trackCircleLayer setNeedsDisplay];
	}
}

#pragma mark - Drawing Code

- (void)initalizeLayers {
	CGPoint arcCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

	self.trackCircleLayer = [[HTACircularLayer alloc] initWithCenter:arcCenter];
	self.trackCircleLayer.radius = self.trackRadius;
	self.trackCircleLayer.frame = self.bounds;
	[self.layer addSublayer:self.trackCircleLayer];

	self.progressCircleLayer = [[HTACircularLayer alloc] initWithCenter:arcCenter];
	self.progressCircleLayer.frame = self.bounds;
	self.progressCircleLayer.strokeEnd = 0.0f;
	[self.layer addSublayer:self.progressCircleLayer];
}

#pragma mark - Setup Animation

- (void)setupAnimation {
	self.strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	self.strokeEndAnimation.delegate = self;
}

#pragma mark - Progress Methods

/**
 *  Methods clamps the `progress` value between 0 and 1. Optionally animates.
 *
 *  @param progress Progress Value
 *  @param animated Should animate
 */

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
	CGFloat clampedProgress = MIN(MAX(progress, 0.0f), 1.0f);
	if (animated) {
		/*
		   Please refer to iOS Core Animation, Advanced Techniques by Nick Lockwood
		   for more information on why this juggling needs to be done.

		   If the presentation layer is present get the fromValue in the presentation layer
		   else get it from the layer's model.
		 */
		self.strokeEndAnimation.fromValue = [self.progressCircleLayer.presentationLayer ? :self.progressCircleLayer valueForKeyPath:self.strokeEndAnimation.keyPath];
		self.strokeEndAnimation.toValue = @(clampedProgress);
		// Update the model without animation
		[self updateModelWithNoAnimationWithProgress:clampedProgress];
		// Setup animation duration
		self.strokeEndAnimation.duration = fabsf(self.progress - clampedProgress);
		// Add animation
		[self.progressCircleLayer addAnimation:self.strokeEndAnimation forKey:nil];
	}
	else {
		[self updateModelWithNoAnimationWithProgress:clampedProgress];
	}
	_progress = clampedProgress;
}

- (void)updateModelWithNoAnimationWithProgress:(CGFloat)clampedProgress {
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	self.progressCircleLayer.strokeEnd = clampedProgress;
	[CATransaction commit];
}

- (void)setProgress:(CGFloat)progress {
	[self setProgress:progress animated:NO];
}

#pragma mark - CABasicAnimation End Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	if (flag && self.progress == 1.0) {
		[UIView animateWithDuration:0.2f animations: ^{
		    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
		} completion: ^(BOOL finished) {
		    [UIView animateWithDuration:0.2f animations: ^{
		        self.transform = CGAffineTransformIdentity;
			}];
		}];
	}
}

@end
