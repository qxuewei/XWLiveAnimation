//
//  XWSequentialImageModel.h
//  XWSequentialAnimation
//
//  Created by 邱学伟 on 2017/5/9.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWSequentialImageModel : NSObject

/// 序列帧图片名称
@property (nonatomic, copy) NSString *sequentialImageName;
/// 序列帧图片数量
@property (nonatomic, strong) NSNumber *sequentialImagesCount;
/// 序列帧动画执行时间
@property (nonatomic, strong) NSNumber *sequentialImageAnimationDuration;

+ (instancetype)creatSequentialImageModelWithSequentialImageName:(NSString *)sequentialImageName sequentialImagesCount:(NSNumber *)sequentialImagesCount sequentialImageAnimationDuration:(NSNumber *)sequentialImageAnimationDuration;

@end
