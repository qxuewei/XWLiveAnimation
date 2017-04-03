//
//  FlashGiftModel.h
//  XWFlashAnimationDemo
//
//  Created by 邱学伟 on 2017/4/1.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlashGiftModel : NSObject

@property (nonatomic, copy) NSString *animName; // flash动画名
@property (nonatomic, copy) NSString *zipUrl;   // 压缩包路径 - 网络更新flash动画备用
@property (nonatomic, copy) NSString *version;  // 该动画版本 - 判断是否需要更新此动画效果

@end
