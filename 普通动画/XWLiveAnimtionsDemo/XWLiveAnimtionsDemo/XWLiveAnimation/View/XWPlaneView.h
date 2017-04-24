//
//  XWPlaneView.h
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/4/10.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FinishPlaneBlock)();

@interface XWPlaneView : UIView
/**
 *  加载动画视图
 *  @return 返回你需要的动画视图
 */

+ (nullable instancetype)loadPlaneViewWithPoint:(CGPoint)point;


/**
 *  设置动画的运行轨迹
 *  注：调此方法前，如需要设置多于两个控制点的动画，请先设置好curve_control_point_*及curve_end_point_*位置
 其它属性也是一样，在调此方法前设置好
 *  @param movePoints 开始的位置(出发点)
 *  @param endPoint   最终动画所在停留的位置
 */
- (void)addAnimationsMoveToPoint:(CGPoint)movePoints endPoint:(CGPoint)endPoint finishPlaneBlock:(FinishPlaneBlock _Nullable )finishPlaneBlock;

@end
