//
//  XWShakeLabel.h
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWShakeLabel : UILabel


// 动画时间
@property (nonatomic,assign) NSTimeInterval duration;
// 描边颜色
@property (nonatomic,strong) UIColor *borderColor;
// 开始礼物数字动画
- (void)startAnimWithDuration:(NSTimeInterval)duration;


@end
