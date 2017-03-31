//
//  XWFlashManager.h
//  FlashAnimtionDemo
//
//  Created by 邱学伟 on 2017/3/21.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashViewCommon.h"
@class FlashViewNew;

@interface XWFlashManager : NSObject

+ (instancetype)shareInstance;

- (void)playFlashAnimationWithName:(NSString *)animName endBlock:(FlashAnimCallback)animEnd;

-(void)playNetWorkFlashAnimationWithURL:(NSString *)url;

@end
