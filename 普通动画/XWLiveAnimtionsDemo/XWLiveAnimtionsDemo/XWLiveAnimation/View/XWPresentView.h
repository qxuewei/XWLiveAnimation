//
//  XWPresentView.h
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//  普通动画

#import "XWBaseAnimView.h"

@interface XWPresentView : XWBaseAnimView

@property (nonatomic,strong) UIImageView *headImageView; // 头像
@property (nonatomic,strong) UIImageView *giftImageView; // 礼物

- (void)hideCurretView;

@end
