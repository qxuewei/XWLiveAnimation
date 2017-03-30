//
//  XWBaseAnimView.h
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWShakeLabel.h"
#import "XWGiftModel.h"

typedef void(^completeBlock)(BOOL finished,NSInteger finishCount);

@interface XWBaseAnimView : UIView

@property (nonatomic,strong) XWGiftModel *model;
@property (nonatomic,strong) UIImageView *userInfoAnimView;   //用户信息动画
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic,strong) UILabel *nameLabel; // 送礼物者
@property (nonatomic,strong) UILabel *giftLabel; // 礼物名称
@property (nonatomic,strong) XWShakeLabel *skLabel;
@property (nonatomic,assign) NSInteger animCount; // 动画执行到了第几次
@property (nonatomic,assign) CGRect originFrame; // 记录原始坐标

// 新增了回调参数 finishCount， 用来记录动画结束时累加数量，将来在几秒内，还能继续累加
@property (nonatomic,copy) void(^completeBlock)(BOOL finished,NSInteger finishCount);

// 动画是否完成
@property (nonatomic,assign,getter=isFinished) BOOL finished;

/// 初始化自定义动画
-(void)setupCustomView;

/// 初始化公共自定义动画
-(void)pubicView;

/// 动画完成后的回调
- (void)animateWithCompleteBlock:(completeBlock)completed;

/// 显示 x 礼物的数量动画
- (void)shakeNumberLabel;

/// 隐藏当前动画视图
- (void)hideCurretView;

/// 重置当前视图的frame
- (void)resetframe;

/// 取一个随机整数，范围在[from,to），包括from，包括to
-(int)getRandomNumber:(int)from to:(int)to;

/// 初始化用户打赏信息
-(void)setupUserInfoAnimView:(XWGiftModel *)model;

// 执行用户打赏信息动画
-(void)showUserInfoAinm;


@end
