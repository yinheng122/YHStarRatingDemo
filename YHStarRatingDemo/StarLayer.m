//
//  StarLayer.m
//  YHStarRatingDemo
//
//  Created by yinheng on 2018/6/14.
//  Copyright © 2018年 yinheng. All rights reserved.
//

#import "StarLayer.h"
#import <CoreText/CoreText.h>
#define starWidth self.bounds.size.width/_starCount
#define imageStarWidth (_layerWidth - _spaceNum * (_starCount - 1))/_starCount
@interface StarLayer()

/**
 * 遮盖layer
 */
@property (strong, nonatomic) CALayer *maskLayer;

/**
 * 灰色图层
 */
@property (strong, nonatomic) CAReplicatorLayer *RlayerGray;

/**
 * 主图层
 */
@property (strong, nonatomic) CAReplicatorLayer *Rlayer;

/**
 * 灰色5角星图层
 */
@property (strong, nonatomic) CAShapeLayer *SlayerGray;

/**
 * 5角星图层
 */
@property (strong, nonatomic) CAShapeLayer *Slayer;

/**
 * 当前的分数百分比
 */
@property (assign, nonatomic) CGFloat percentage;

/**
 * 储存设置的宽度
 */
@property (assign, nonatomic) CGFloat layerWidth;
@end


@implementation StarLayer

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI{
    _wordFont = 15;
    _starCount = 5;
    _currentScore = 0;
    _decimal = YES;
    _color = [UIColor redColor];
    _darkColor = [UIColor lightGrayColor];
    CGRect frame = self.frame;
    _layerWidth = self.frame.size.width;
    frame.size.height = _wordFont;
    frame.size.width = [self calculateRowWidth:@"★"] *_starCount + (_starCount - 1)* _spaceNum;
    self.frame = frame;
    [self buildStarLayer];
}

- (void)setSpaceNum:(NSInteger)spaceNum{
    _spaceNum = spaceNum;
    [self resetLayerFrame];
}

- (void)setWordfont:(CGFloat)wordfont{
    _wordFont = wordfont;
    [self resetLayerFrame];
}

- (void)setCurrentScore:(CGFloat)currentScore{
    _currentScore = currentScore;
    if (_decimal) {
        _percentage = currentScore/_starCount;
    }else{
        _percentage = ceilf(currentScore)/_starCount;
    }
}

- (void)setStarCount:(NSInteger)starCount{
    _starCount = starCount;
    [self resetLayerFrame];
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
    
    if (self.returnScoreBlock) {
        if (percentage < 0) {
            self.returnScoreBlock(0);
            return;
        }
        if (_decimal) {
            self.returnScoreBlock(percentage * _starCount);
        }else{
            if (ceilf(percentage * _starCount) >_starCount) {
                self.returnScoreBlock(_starCount);
            }else{
                self.returnScoreBlock(ceilf(percentage * _starCount));
            }
        }
        
    }
    
}

- (void)setCanDrag:(BOOL)canDrag{
    _canDrag = canDrag;
    if (_canDrag) {
        // 添加手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheStar:)];
        [self addGestureRecognizer:tap];
    }
}

- (void)setColor:(UIColor *)color{
    _color = color;
    [self resetLayerFrame];
}

- (void)setDarkColor:(UIColor *)darkColor{
    _darkColor = darkColor;
    [self resetLayerFrame];
}

- (void)setImageLayer:(BOOL)imageLayer{
    _imageLayer = imageLayer;
    [self buildShapeLayer:self.Slayer color:nil];
    [self buildShapeLayer:self.SlayerGray color:nil];
    [self resetLayerFrame];
}

/**
 * 重新设置视图
 */
- (void)resetLayerFrame{
    if (self.imageLayer) {
        CGRect frame = self.frame;
        frame.size.height = _layerWidth;
        frame.size.width = _layerWidth;
        self.frame = frame;
        self.Rlayer.instanceTransform = CATransform3DMakeTranslation(imageStarWidth +_spaceNum, 0, 0);
        self.RlayerGray.instanceTransform = CATransform3DMakeTranslation(imageStarWidth +_spaceNum, 0, 0);
    }else{
        CGRect frame = self.frame;
        frame.size.height = [self calculateRowHeight:@"★"];
        frame.size.width = [self calculateRowWidth:@"★"] *_starCount + (_starCount - 1)* _spaceNum;
        self.frame = frame;
        self.Rlayer.instanceTransform = CATransform3DMakeTranslation([self calculateRowWidth:@"★"] +_spaceNum, 0, 0);
        self.RlayerGray.instanceTransform = CATransform3DMakeTranslation([self calculateRowWidth:@"★"] +_spaceNum, 0, 0);
        self.Slayer.path = [self bezierPathWithText:@"★" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:_wordFont]}].CGPath;
        self.SlayerGray.path = [self bezierPathWithText:@"★" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:_wordFont]}].CGPath;
        self.Slayer.frame = CGRectMake(0, -_wordFont/4.f, starWidth, self.bounds.size.height);
        self.SlayerGray.frame = CGRectMake(0, -_wordFont/4.f, starWidth, self.bounds.size.height);
        self.Slayer.strokeColor = _color.CGColor;
        self.Slayer.fillColor = _color.CGColor;
        self.SlayerGray.strokeColor = _darkColor.CGColor;
        self.SlayerGray.fillColor = _darkColor.CGColor;
    }
    self.Rlayer.instanceCount = _starCount;
    self.RlayerGray.instanceCount = _starCount;
}

- (void)buildStarLayer{

    self.RlayerGray = [[CAReplicatorLayer alloc] init];
    [self buildReplicatorLayer:self.RlayerGray];

    self.SlayerGray = [[CAShapeLayer alloc] init];
    [self buildShapeLayer:self.SlayerGray color:_darkColor];
    [self.RlayerGray addSublayer:self.SlayerGray];
    
    self.Rlayer = [[CAReplicatorLayer alloc] init];
    [self buildReplicatorLayer:self.Rlayer];
    
    self.Slayer = [[CAShapeLayer alloc] init];
    [self buildShapeLayer:self.Slayer color:_color];
    [self.Rlayer addSublayer:self.Slayer];
    
    self.maskLayer = [[CALayer alloc] init];
    self.maskLayer.frame = CGRectMake(0, 0, starWidth * _currentScore , starWidth);
    self.maskLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    self.Rlayer.mask = self.maskLayer;
    
}

- (void)buildReplicatorLayer:(CAReplicatorLayer *)rlayer{
    rlayer.frame = CGRectMake(0, 0, _layerWidth, imageStarWidth);
    rlayer.instanceCount = _starCount;
    if (_imageLayer) {
        rlayer.instanceTransform = CATransform3DMakeTranslation(imageStarWidth + _spaceNum, 0, 0);
    }else{
        rlayer.instanceTransform = CATransform3DMakeTranslation([self calculateRowWidth:@"★"] + _spaceNum, 0, 0);
    }
    
    [self.layer addSublayer:rlayer];
}

- (void)buildShapeLayer:(CAShapeLayer *)slayer color:(UIColor *)color{
    if (_imageLayer) {
        slayer.frame = CGRectMake(0, 0, imageStarWidth, imageStarWidth);
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, imageStarWidth, imageStarWidth);
        if ([slayer isEqual:self.Slayer]) {
            imageView.image = [UIImage imageNamed:@"star"];
        }else{
            imageView.image = [UIImage imageNamed:@"grayStar"];
        }
        slayer.path = nil;
        slayer.geometryFlipped = NO;
        [slayer addSublayer:imageView.layer];
    }else{
        slayer.frame = CGRectMake(0, -_wordFont/4.f, starWidth, self.bounds.size.height);
        slayer.path = [self bezierPathWithText:@"★" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:_wordFont]}].CGPath;
        slayer.geometryFlipped = YES;
        slayer.strokeColor = color.CGColor;
        slayer.fillColor = color.CGColor;
    }
}

- (void)tapTheStar:(UITapGestureRecognizer *)recognizer{
    static CGFloat startX = 0;
    CGFloat starScorePercentage = 0;
    startX = [recognizer locationInView:self].x;
    starScorePercentage = startX / self.bounds.size.width;
    self.percentage = starScorePercentage;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
    static CGFloat startX = 0;
    CGFloat starScorePercentage = 0;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startX = [recognizer locationInView:self].x;
        starScorePercentage = startX / self.bounds.size.width;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat location = [recognizer translationInView:self].x + startX;
        starScorePercentage = location / self.bounds.size.width;
    } else {
        return;
    }
    
    self.percentage = starScorePercentage;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak StarLayer *weakSelf = self;
    [UIView animateWithDuration:0 animations:^{
        if (!_decimal) {
           weakSelf.maskLayer.frame = CGRectMake(0, 0, ceilf(weakSelf.percentage * _starCount)/_starCount * weakSelf.bounds.size.width, weakSelf.bounds.size.height);
        }else{
           weakSelf.maskLayer.frame = CGRectMake(0, 0, weakSelf.percentage * weakSelf.bounds.size.width, weakSelf.bounds.size.height);
        }
    }];
}

/**
 * 根据文字加载贝塞尔曲线视图
 */
- (UIBezierPath *)bezierPathWithText:(NSString *)text attributes:(NSDictionary *)attrs; {
    NSAssert(text!= nil && attrs != nil, @"参数不能为空");
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text
                                                                     attributes:attrs];
    CGMutablePathRef paths = CGPathCreateMutable();
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            {
                CGPathRef path = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(paths, &t,path);
                CGPathRelease(path);
            }
        }
    }
    CFRelease(line);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:paths]];
    CGPathRelease(paths);
    return path;
}

- (CGFloat)calculateRowWidth:(NSString *)string {
    // 指定字号
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:_wordFont]};
    // 计算宽度时要确定高度
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, _wordFont) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

- (CGFloat)calculateRowHeight:(NSString *)string{
    // 指定字号
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:_wordFont]};
    // 计算高度要先指定宽度
    CGRect rect = [string boundingRectWithSize:CGSizeMake([self calculateRowWidth:@"★"], 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}
@end
