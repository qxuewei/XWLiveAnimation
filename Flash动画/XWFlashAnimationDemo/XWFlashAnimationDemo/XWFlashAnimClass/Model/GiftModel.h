//
//  GiftModel.h
//  XWFlashAnimationDemo
//
//  Created by 邱学伟 on 2017/4/1.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : NSObject

@property (strong, nonatomic) NSString *giftID;
@property (strong, nonatomic) NSString *giftUrl;
@property (strong, nonatomic) NSString *giftName;
@property (strong, nonatomic) NSString *giftPrice;
@property (strong, nonatomic) NSString *giftType;
@property (strong, nonatomic) NSString *giftNums;//这次展示多少个礼物数
@property (strong, nonatomic) NSString *giftIndex;//这次从第几个开始展示

@end
