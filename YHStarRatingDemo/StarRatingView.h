//
//  StarRatingView.h
//  YHStarRatingDemo
//
//  Created by yinheng on 2018/6/14.
//  Copyright © 2018年 yinheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarRatingView;

@protocol StarRatingViewDelegate <NSObject>

/**
 *  通知代理改变评分到某一特定的值
 *
 *  @param starRateView 指当前评分view
 *  @param percentage   新的评分值
 */
- (void)starRateView:(StarRatingView *)starRateView didChangedScorePercentageTo:(CGFloat)percentage;

@end

@interface StarRatingView : UIView

/**
 *  代理
 */
@property (weak, nonatomic) id<StarRatingViewDelegate> delegate;
/**
 *  是否使用动画，默认为NO
 */
@property (assign, nonatomic) BOOL shouldUseAnimation;
/**
 *  是否允许非整型评分，默认为NO
 */
@property (assign, nonatomic) BOOL allowIncompleteStar;
/**
 *  是否允许用户手指操作评分,默认为YES
 */
@property (assign, nonatomic) BOOL allowUserInteraction;

/**
 *  当前评分值，范围0---1，表示的是黄色星星占的百分比,默认为1
 */
@property (assign, nonatomic) CGFloat percentage;

/**
 *  初始化方法，需传入评分星星的总数
 *
 *  @param frame 该starView的大小与位置
 *  @param count 评分星星的数量
 *
 *  @return 实例变量
 */
- (id)initWithFrame:(CGRect)frame starCount:(NSInteger)count;


@end
