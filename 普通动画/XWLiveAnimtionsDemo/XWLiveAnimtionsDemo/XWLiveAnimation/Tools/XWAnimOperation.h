//
//  XWAnimOperation.h
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XWPresentView.h"
#import "XWGiftModel.h"

#import "XWRightAnimView.h"
#import "XWMarkAnimView.h"
//#import "XWOceanAnimView.h"
//#import "XWCastleAnimView.h"

typedef NS_ENUM(NSInteger, GIFT_INDEX) {
    GIFT_INDEX_queue1          = 1,     //普通队列1
    GIFT_INDEX_queue2          = 0,     //普通队列2
    GIFT_INDEX_rightQueue      = 3,     //爱心守护者和咖啡印记 队列
    GIFT_INDEX_markQueue       = 4,     //贵族面具队列
    GIFT_INDEX_oceanQueue      = 5,     //海洋之星队列
    GIFT_INDEX_castleQueue     = 6      //女皇的城堡队列
};

@interface XWAnimOperation : NSOperation

@property (nonatomic,strong) XWPresentView *presentView;
@property (nonatomic,strong) UIView *listView;

@property (nonatomic,strong) XWRightAnimView *rightAnimView;  //右边动画
@property (nonatomic,strong) UIView *rightAnimlistView;

//@property (nonatomic,strong) XWOceanAnimView *oceanAnimView;  //海洋之星动画
//@property (nonatomic,strong) UIView *oceanAnimlistView;
//
//@property (nonatomic,strong) XWCastleAnimView *castleAnimView;  //女皇的城堡动画
//@property (nonatomic,strong) UIView *castleAnimlistView;
//
@property (nonatomic,strong) XWMarkAnimView *markAnimView;      //贵族面具动画
@property (nonatomic,strong) UIView *markAnimlistView;

@property (nonatomic,strong) XWGiftModel *model;
@property (nonatomic)  enum  GIFT_INDEX index;  //属于那个队列


// 回调参数增加了结束时礼物累计数
+ (instancetype)animOperationWithGiftModel:(XWGiftModel *)model finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock;




@end
