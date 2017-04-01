//
//  UIView+XWAnimate.h
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/4/1.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XWAnimate)
/**
 从上往下浮动 无限重复
 
 @param upDownAnimationView 动画的视图
 @param animUpToDownHight 浮动的高度
 */
+(void)upDownAnimation:(UIView *)upDownAnimationView withAnimUpToDownHight:(float )animUpToDownHight;

/**
 从上往下浮动
 
 @param upDownAnimationView 动画的视图
 @param animUpToDownHight 浮动的高度
 @param duration 动画的时间
 @param repeatCount 重复的次数
 */
+(void)upDownAnimation:(UIView *)upDownAnimationView withAnimUpToDownHight:(float )animUpToDownHight withDuration:(float)duration withRepeatCount:(float)repeatCount;

/**
 从下往上浮动 无限重复
 
 @param animationView 动画的视图
 @param animUpToDownHight 浮动的高度
 */
+(void)downUpAnimation:(UIView *)animationView withAnimUpToDownHight:(float )animUpToDownHight;

/**
 从下往上浮动
 
 @param animationView 动画的视图
 @param animUpToDownHight 浮动的高度
 @param duration 动画的时间
 @param repeatCount 重复的次数
 */
+(void)downUpAnimation:(UIView *)animationView withAnimUpToDownHight:(float )animUpToDownHight withDuration:(float)duration withRepeatCount:(float)repeatCount;

/**
 闪动画
 
 @param opacityAnimationView  需要闪的动画
 */
+(void)opacityAnimation:(UIView *)opacityAnimationView;

/**
 闪动画
 
 @param opacityAnimationView 闪动画
 @param duration 闪动画的时间
 */
+(void)opacityAnimation:(UIView *)opacityAnimationView withDuration:(float )duration;


@end
