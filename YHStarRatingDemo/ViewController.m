//
//  ViewController.m
//  YHStarRatingDemo
//
//  Created by yinheng on 15/11/7.
//  Copyright © 2015年 yinheng. All rights reserved.
//

#import "ViewController.h"
#import "StarRatingView.h"
#import "StarLayer.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    StarRatingView *starRatingView = [[StarRatingView alloc] initWithFrame:CGRectMake(10, 10, 100, 100) starCount:5];
    starRatingView.percentage = 0;
    starRatingView.allowIncompleteStar = YES;
    starRatingView.shouldUseAnimation = YES;
    [self.view addSubview:starRatingView];
    
    StarLayer *starLayer = [[StarLayer alloc] initWithFrame:CGRectMake(100, 200, 100, 80)];
    starLayer.spaceNum = 5;
    starLayer.canDrag = YES;
    starLayer.currentScore = 2;
    starLayer.returnScoreBlock = ^(CGFloat score) {
        NSLog(@"%f", score);
    };
    [self.view addSubview:starLayer];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
