//
//  StarLayer.h
//  YHStarRatingDemo
//
//  Created by yinheng on 2018/6/14.
//  Copyright © 2018年 yinheng. All rights reserved.
//
/**
 * 星星控件
 * veriosn 1.0
 * xcode 9.3
 */
#import <UIKit/UIKit.h>

@interface StarLayer : UIView

/**
 * 当前的分数
 */
@property (assign, nonatomic) CGFloat currentScore;

/**
 * 允许拖动 (默认不允许)
 */
@property (assign, nonatomic) BOOL canDrag;

/**
 * 返回的分数
 */
@property (copy, nonatomic) void(^returnScoreBlock)(CGFloat score);

/**
 * 是否允许分数带有小数
 */
@property (assign, nonatomic) BOOL decimal;

/**
 * 渲染的颜色
 */
@property (strong, nonatomic) UIColor *color;

/**
 * 灰色图层的颜色
 */
@property (strong, nonatomic) UIColor *darkColor;

/**
 * 需要展示的评星个数 (默认5个)
 */
@property (assign, nonatomic) NSInteger starCount;

/**
 * 文字大小，视图根据文字大小确定高宽 (默认15)
 */
@property (assign, nonatomic) CGFloat wordFont;

/**
 * 星星之间的间距 (默认0)
 */
@property (assign, nonatomic) NSInteger spaceNum;

/**
 * 是否是用image做图层 (默认是文字贝塞尔)
 */
@property (assign, nonatomic) BOOL imageLayer;

@end
