//
//  XWAnimationImageCache.m
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWAnimationImageCache.h"

@implementation XWAnimationImageCache

+ (instancetype)shareInstance
{
    static XWAnimationImageCache *share;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[XWAnimationImageCache alloc] init];
        
    });
    return share;
}

- (instancetype)init {
    if (self = [super init]) {
        
        //用NSCache持有引用
        
        
    }
    return self;
}

//注意，当收到内存不足警告时，NSCache会自动释放内存。所以每次访问NSCache，即使上一次已经加载过，也需要判断返回值是否为空。
-(UIImage *)getImageWithName:(NSString *)name{
    
    return [UIImage imageNamed:name];
}


@end
