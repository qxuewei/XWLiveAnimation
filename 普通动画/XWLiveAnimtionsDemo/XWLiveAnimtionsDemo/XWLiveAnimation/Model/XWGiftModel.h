//
//  XWGiftModel.h
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XWUserInfo.h"

typedef NS_ENUM(NSInteger, GIFT_TYPE) {
    GIFT_TYPE_DEFAULT    = 0,     //普通
    GIFT_TYPE_MASK       = 1,     //贵族面具
    GIFT_TYPE_OCEAN      = 2,     //海洋之星
    GIFT_TYPE_GUARD      = 3,     //爱心守护者
    GIFT_TYPE_COOFFEE    = 4,     //咖啡印记
    GIFT_TYPE_CASTLE     = 5      //女皇的城堡
};

@interface XWGiftModel : NSObject

@property (nonatomic, assign) long giftId;             // 礼物的id
@property (nonatomic, copy) NSString *giftName;        // 礼物名称
@property (nonatomic, copy) NSString *giftPic;         // 礼物图片
@property (nonatomic) enum GIFT_TYPE giftType;        // 礼物类型
@property (nonatomic, assign)  NSInteger sort;         // 礼物的排序
@property (nonatomic, strong) XWUserInfo *user;     // 送礼者
@property (nonatomic, assign) NSInteger giftCount;  // 礼物个数

/// 自定义属性
@property (nonatomic, strong) UIImage *headImage; // 头像
@property (nonatomic, strong) UIImage *giftImage; // 礼物图像


@end
