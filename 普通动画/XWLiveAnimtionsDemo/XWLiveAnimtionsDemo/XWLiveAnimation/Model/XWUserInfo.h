//
//  XWUserInfo.h
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWUserInfo : NSObject

@property (nonatomic, assign) long userId;//用户id, 由后台分配
@property (nonatomic, copy)   NSString *userName;//用户昵称
@property (nonatomic, assign) int sex;//1男,2女
@property (nonatomic, copy)   NSString *headPic;//用户头像
@property (nonatomic, copy)   NSString *bgPic;//背景，保留
@property (nonatomic, assign) long birthDay;//生日,保留
@property (nonatomic, copy)   NSString *area;//所在区域
@property (nonatomic, copy)   NSString *intro;//个人介绍
@property (nonatomic, copy)   NSString *address;//联系地址
@property (nonatomic, copy)   NSString *contact;//联系方式
@property (nonatomic, copy)   NSString *phoneNum; //电话

@end
