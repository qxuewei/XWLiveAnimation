//
//  XWFlashManager.h
//  FlashAnimtionDemo
//
//  Created by 邱学伟 on 2017/3/21.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashViewCommon.h"
@class FlashViewNew,FlashGiftModel;
@interface XWFlashManager : NSObject
/// 单例对象
+ (instancetype)shareInstance;
/// 获取当前flashView
- (FlashViewNew *)getFlashView;
/// 开机获取flash动画 Url和version以及animName 下载压缩包并解压
- (void)downloadAndUnZipWith:(FlashGiftModel *)flashGiftModel;
/// 播放flash动画
- (void)playFlashAnimation:(FlashGiftModel *)flashGiftModel endBlock:(FlashAnimCallback)animEnd;
@end
