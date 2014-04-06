//
//  HTAViewController.m
//  HTACircularProgressView
//
//  Created by Malolan on 4/1/14.
//  Copyright (c) 2014 Haptrix. All rights reserved.
//

#import "HTAViewController.h"

#import "HTACircularProgressView.h"

@implementation HTAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frameRect = CGRectMake(self.view.center.x - 50.0f , self.view.center.y - 50.0f, 100.0f, 100.0f);
    
    self.circularProgressBar = [[HTACircularProgressView alloc] initWithFrame:frameRect];
    [self.view addSubview:self.circularProgressBar];
    
    [self.startButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked:(id)sender {

    [self.circularProgressBar setProgress:1.0f animated:YES];
}

@end
