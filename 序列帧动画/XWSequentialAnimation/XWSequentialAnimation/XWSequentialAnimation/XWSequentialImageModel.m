//
//  XWSequentialImageModel.m
//  XWSequentialAnimation
//
//  Created by 邱学伟 on 2017/5/9.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWSequentialImageModel.h"

@implementation XWSequentialImageModel

+ (instancetype)creatSequentialImageModelWithSequentialImageName:(NSString *)sequentialImageName sequentialImagesCount:(NSNumber *)sequentialImagesCount sequentialImageAnimationDuration:(NSNumber *)sequentialImageAnimationDuration {
    return [[self alloc] initWithSequentialImageName:sequentialImageName sequentialImagesCount:sequentialImagesCount sequentialImageAnimationDuration:sequentialImageAnimationDuration];
}

- (instancetype)initWithSequentialImageName:(NSString *)sequentialImageName sequentialImagesCount:(NSNumber *)sequentialImagesCount sequentialImageAnimationDuration:(NSNumber *)sequentialImageAnimationDuration {
    if (self = [super init]) {
        self.sequentialImageName = sequentialImageName;
        self.sequentialImagesCount = sequentialImagesCount;
        self.sequentialImageAnimationDuration = sequentialImageAnimationDuration;
    }
    return self;
}

@end
