//
//  StarRatingView.m
//  YHStarRatingDemo
//
//  Created by yinheng on 2018/6/14.
//  Copyright © 2018年 yinheng. All rights reserved.
//

#import "StarRatingView.h"

@interface StarRatingView()

/**
 * 星星数量
 */
@property (assign, nonatomic) NSInteger starCount;

/**
 * 星星宽度
 */
@property (assign, nonatomic) CGFloat starWidth;

/**
 * 高亮星星视图
 */
@property (strong, nonatomic) UIView *lightStarView;

/**
 * 未选中时的星星视图
 */
@property (strong, nonatomic) UIView *grayStarView;

@end

@implementation StarRatingView

- (id)initWithFrame:(CGRect)frame starCount:(NSInteger)count {
    self = [super initWithFrame:frame];
    if (self) {
        self.starCount = count;
        self.starWidth = (CGFloat)self.frame.size.width / self.starCount;
        
        [self initStarView];
    }
    return self;
}

- (void)initStarView {
    //默认值
    self.percentage = 0.0f;
    self.shouldUseAnimation = NO;
    self.allowIncompleteStar = NO;
    self.allowUserInteraction = YES;
    
    //星星视图
    self.lightStarView = [self starViewWithImageName:@"star"];
    self.grayStarView = [self starViewWithImageName:@"grayStar"];
    
    [self addSubview:self.grayStarView];
    [self addSubview:self.lightStarView];
    
    //此处用pan手势，达到用户可以滑动手指评分的效果
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
}

- (UIView *)starViewWithImageName:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    //添加星星
    for (int i = 0; i < self.starCount; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.starWidth, 0, self.starWidth, self.bounds.size.height)];
        iv.image = [UIImage imageNamed:imageName];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:iv];
    }
    
    return view;
}


- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    static CGFloat startX = 0;
    CGFloat starScorePercentage = 0;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startX = [recognizer locationInView:self].x;
        starScorePercentage = startX / self.starWidth;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat location = [recognizer translationInView:self].x + startX;
        starScorePercentage = location / self.starWidth;
        
    } else {
        return;
    }
    
    CGFloat realScore = self.allowIncompleteStar ? starScorePercentage : ceilf(starScorePercentage);
    self.percentage = realScore / self.starCount;
}

- (void)setPercentage:(CGFloat)percentage {
    
    if (percentage >= 1) {
        _percentage = 1;
    } else if (percentage < 0) {
        _percentage = 0;
    } else {
        _percentage = percentage;
    }
    
    [self setNeedsLayout];
    
    if ([self.delegate respondsToSelector:@selector(starRateView:didChangedScorePercentageTo:)]) {
        [self.delegate starRateView:self didChangedScorePercentageTo:_percentage];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak StarRatingView *weakSelf = self;
    
    CGFloat duration = self.shouldUseAnimation ? 1 : 0.0f;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.lightStarView.frame = CGRectMake(0, 0, weakSelf.percentage * weakSelf.bounds.size.width, weakSelf.bounds.size.height);
    }];
}

@end
