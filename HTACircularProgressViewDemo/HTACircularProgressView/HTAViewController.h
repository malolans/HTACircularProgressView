//
//  HTAViewController.h
//  HTACircularProgressView
//
//  Created by Malolan on 4/1/14.
//  Copyright (c) 2014 Haptrix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTACircularProgressView;

@interface HTAViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) HTACircularProgressView *circularProgressBar;

@end
