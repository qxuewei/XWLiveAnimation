//
//  XWAnimOperationManager.h
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XWGiftModel.h"

@interface XWAnimOperationManager : NSObject

@property (nonatomic,strong) UIView *parentView;
@property (nonatomic,strong) XWGiftModel *model;

+ (instancetype)shareInstance;

/// 动画操作
- (void)animWithGiftModel:(XWGiftModel *)model finishedBlock:(void(^)(BOOL result))finishedBlock;

/// 取消上一次的动画操作
- (void)cancelOperationWithLastGift:(XWGiftModel *)model;

//// 获得用户唯一标示reuseIdentifier，记录礼物信息的标示信息
-(NSString *)getUserReuseIdentifierID:(XWGiftModel *)model;

/// 注销释放内存
-(void)resetDealloc;

@end
