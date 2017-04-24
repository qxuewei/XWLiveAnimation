//
//  XWPlaneView.m
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/4/10.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWPlaneView.h"

@interface XWPlaneView () <CAAnimationDelegate>
@property (nonatomic, strong) UIImageView *planeWing;
@property (weak, nonatomic) IBOutlet UIImageView *planeScrew;

@property (nonatomic, copy) FinishPlaneBlock finishPlaneAnimBlock;

/**
 *  需要几个控制点就设置几个:
 *  数组内的每个元素代码一个控制点和结束点
 *  数组中放CGRect数据，CGRect的x和y分别作为控制点的x和y，CGRect的width和height作为结束点的x和y
 */
@property (nullable, nonatomic, copy) NSArray *curveControlAndEndPoints;

/**
 *  动画结束后动画层是否从当前视图上移除，默认 NO
 */
@property (nonatomic, assign) BOOL removedOnCompletion;

/**
 *  从(from)scale 到(to)scale 默认0.7 - 2.0
 */
@property (nullable, strong) id scaleFromValue;
@property (nullable, strong) id scaleToValue;

@end
#define SUB_RESOURCE @"liveAnimResource.bundle/%@%d"
@implementation XWPlaneView

+ (instancetype)loadPlaneViewWithPoint:(CGPoint)point{
    XWPlaneView *plane = [[NSBundle mainBundle]loadNibNamed:@"XWPlaneView" owner:self options:nil].lastObject;
    plane.frame = CGRectMake(point.x, point.y, 232, 92);
    [plane setPoints];
    [plane setPlaneScrew];
    return plane;
}

- (void)setPoints{
    _scaleToValue = [NSNumber numberWithFloat:2.0];
    _scaleFromValue = [NSNumber numberWithFloat:0.7];
    NSMutableArray *pointArrs = [[NSMutableArray alloc] init];
    [pointArrs addObject:NSStringFromCGRect(CGRectMake(290, 250, 290, 250))];
    [pointArrs addObject:NSStringFromCGRect(CGRectMake(290, 250, 290, 250))];
    [pointArrs addObject:NSStringFromCGRect(CGRectMake(290, 250, 290, 250))];
    [pointArrs addObject:NSStringFromCGRect(CGRectMake(290, 250, 290, 250))];
    self.curveControlAndEndPoints = pointArrs;
}

// 开启螺旋桨动画
- (void)setPlaneScrew{
    NSMutableArray* images = [NSMutableArray array];
    for(int i = 1;i<4;i++){
        [images addObject: [UIImage imageNamed:[NSString stringWithFormat:SUB_RESOURCE,@"plane-screw-4-",i]]];
    }
    _planeScrew.animationImages = images;
    _planeScrew.animationDuration = 0.05;
    _planeScrew.animationRepeatCount = 0;
    [_planeScrew startAnimating];
}

- (void)addAnimationsMoveToPoint:(CGPoint)movePoints endPoint:(CGPoint)endPoint finishPlaneBlock:(FinishPlaneBlock _Nullable)finishPlaneBlock{
    if (finishPlaneBlock) {
        self.finishPlaneAnimBlock = finishPlaneBlock;
    }
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, movePoints.x, movePoints.y);
    
    [self.curveControlAndEndPoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = CGRectFromString(obj);
        CGPathAddQuadCurveToPoint(path, NULL, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    }];
    
    CGPathAddQuadCurveToPoint(path, NULL, endPoint.x, endPoint.y, endPoint.x, endPoint.y);
    position.path = path;
    position.duration = 4.f;
    position.speed = 0.6;
    position.removedOnCompletion = NO;
    position.fillMode = kCAFillModeForwards;
    position.calculationMode = kCAAnimationCubicPaced;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.duration = 1.0;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 7.f;
    animationGroup.delegate = self;
    animationGroup.autoreverses = NO;
    animationGroup.repeatCount = 0;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.animations = @[scaleAnimation,position];
    [self.layer addAnimation:animationGroup forKey:@"planeViews"];
    
}

#pragma CAAnimationDelegate
/* Called when the animation begins its active duration. */

- (void)animationDidStart:(CAAnimation *)anim{
//    NSLog(@"animationDidStart");
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    NSLog(@"animationDidStop");
    if (self.finishPlaneAnimBlock) {
        self.finishPlaneAnimBlock();
    }
}


@end
