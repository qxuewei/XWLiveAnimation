//
//  XWAnimationImageCache.h
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 动画图片缓存，使用单例获取图片缓存
 */
@interface XWAnimationImageCache : NSCache

+ (instancetype)shareInstance;

/**
 获得缓冲里面的图片
 
 @param name 图片名称
 @return 返回UIImage
 */
- (UIImage *)getImageWithName:(NSString *)name;



@end
