//
//  HTACircularProgressView.h
//  HTACircularProgressView
//
//  Created by Malolan on 4/1/14.
//  Copyright (c) 2014 Haptrix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTACircularProgressView : UIView

/**
 *  The current progress shown by the Control.
 */
@property (assign, nonatomic) CGFloat progress;

/**
 *  The color of the progress indicator circle.
 */
@property (strong, nonatomic) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;

@property (assign, nonatomic) CGFloat progressStrokeWidthRatio UI_APPEARANCE_SELECTOR;

/**
 *  The color of the outer track circle.
 */
@property (strong, nonatomic) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;

@property (assign, nonatomic) CGFloat trackStrokeWidthRatio UI_APPEARANCE_SELECTOR;

/**
 *  Set the current progress shown by the Control. The progress could be animated.
 *
 *  @param progress CGFloat value between 0-1. Values outside the range are clamped.
 *  @param animated YES if the progress change should be animated. NO for instant change.
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
