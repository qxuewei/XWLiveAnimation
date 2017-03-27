//
//  XWFlashManager.h
//  FlashAnimtionDemo
//
//  Created by 邱学伟 on 2017/3/21.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FlashViewNew;

@interface XWFlashManager : NSObject

+ (instancetype)shareInstance;

- (void)playFlashAnimationWithName:(NSString *)animName;

-(void)playNetWorkFlashAnimationWithURL:(NSString *)url;

@end
