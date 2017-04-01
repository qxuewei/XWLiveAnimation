//
//  UIView+XWAnimate.m
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/4/1.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "UIView+XWAnimate.h"

@implementation UIView (XWAnimate)

// 上下浮动 无限浮动
+(void)upDownAnimation:(UIView *)upDownAnimationView withAnimUpToDownHight:(float )animUpToDownHight{
    [self upDownAnimation:upDownAnimationView withAnimUpToDownHight:animUpToDownHight withDuration:0.5 withRepeatCount:HUGE_VALF];
}
// 上下浮动
+(void)upDownAnimation:(UIView *)upDownAnimationView withAnimUpToDownHight:(float )animUpToDownHight withDuration:(float)duration withRepeatCount:(float)repeatCount;
{
    
    CAKeyframeAnimation *upDownAnimation;
    upDownAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    upDownAnimation.values = @[@(upDownAnimationView.layer.position.y), @(upDownAnimationView.layer.position.y + animUpToDownHight),@(upDownAnimationView.layer.position.y)];
    upDownAnimation.duration = duration;
    upDownAnimation.fillMode = kCAFillModeBoth;
    upDownAnimation.calculationMode = kCAAnimationCubic;
    upDownAnimation.repeatCount = repeatCount;
    [upDownAnimationView.layer addAnimation:upDownAnimation forKey:@"upDownAnimation"];
    
}

+(void)downUpAnimation:(UIView *)animationView withAnimUpToDownHight:(float )animUpToDownHight{
    [self downUpAnimation:animationView withAnimUpToDownHight:animUpToDownHight withDuration:0.5 withRepeatCount:HUGE_VALF];
}
// 下上浮动
+(void)downUpAnimation:(UIView *)animationView withAnimUpToDownHight:(float )animUpToDownHight withDuration:(float)duration withRepeatCount:(float)repeatCount{
    
    CAKeyframeAnimation *downUpAnimation;
    downUpAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    downUpAnimation.values = @[@(animationView.layer.position.y), @(animationView.layer.position.y - animUpToDownHight),@(animationView.layer.position.y)];
    downUpAnimation.duration = duration;
    downUpAnimation.fillMode = kCAFillModeBoth;
    downUpAnimation.calculationMode = kCAAnimationCubic;
    downUpAnimation.repeatCount = repeatCount;
    [animationView.layer addAnimation:downUpAnimation forKey:@"downUpAnimation"];
    
}

+(void)opacityAnimation:(UIView *)opacityAnimationView{
    
    [self opacityAnimation:opacityAnimationView withDuration:0.5];
}

+(void)opacityAnimation:(UIView *)opacityAnimationView withDuration:(float )duration{
    
    CAKeyframeAnimation *opacityAnimation;
    opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@(1), @(0.6), @(1)];
    opacityAnimation.duration = duration;
    opacityAnimation.fillMode = kCAFillModeBoth;
    opacityAnimation.calculationMode = kCAAnimationCubic;
    opacityAnimation.repeatCount = HUGE_VALF;
    [opacityAnimationView.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
}

@end

