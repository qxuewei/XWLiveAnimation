//
//  XWAnimOperation.m
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWAnimOperation.h"

@interface XWAnimOperation ()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);

@end

@implementation XWAnimOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

+ (instancetype)animOperationWithGiftModel:(XWGiftModel *)model finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock; {
    XWAnimOperation *op = [[XWAnimOperation alloc] init];
    
    if (model.giftType == GIFT_TYPE_DEFAULT) { //普通动画
        op.presentView = [[XWPresentView alloc] init];
    }else if (model.giftType == GIFT_TYPE_GUARD) { //爱心守护者
        op.rightAnimView = [[XWRightAnimView alloc] init];
    }else if (model.giftType == GIFT_TYPE_MASK) {  //贵族面具
        op.markAnimView  = [[XWMarkAnimView alloc] init];
    }else if (model.giftType == GIFT_TYPE_OCEAN) { //海洋之星
        op.oceanAnimView = [[XWOceanAnimView alloc]init];
    }else if (model.giftType == GIFT_TYPE_COOFFEE) { //咖啡印记
        op.rightAnimView = [[XWRightAnimView alloc] init];
    }else if (model.giftType == GIFT_TYPE_CASTLE) { //女皇的城堡
        op.castleAnimView = [[XWCastleAnimView alloc] init];
    }
    op.model = model;
    op.finishedBlock = finishedBlock;
    return op;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
    }
    return self;
}

// 添加到队列时调用
- (void)start {
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    if (_model.giftType == GIFT_TYPE_DEFAULT) { //普通动画
        [self addOperationWithPresentView];
    }else if (_model.giftType == GIFT_TYPE_GUARD) { //爱心守护者
        [self addOperationWithPightAnimView];
    }else if (_model.giftType == GIFT_TYPE_MASK) {  //贵族面具
        [self addOperationWithMarkAnimView];
    }else if (_model.giftType == GIFT_TYPE_OCEAN) {  //海洋之星
        [self addOperationWithOceanAnimView];
    }else if (_model.giftType == GIFT_TYPE_COOFFEE) { //咖啡印记
        [self addOperationWithPightAnimView];
    }else if (_model.giftType == GIFT_TYPE_CASTLE) {  //女皇的城堡
        [self addOperationWithCastleAnimView];
    }
}

// 普通动画添加到队列
-(void) addOperationWithPresentView{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _presentView.model = _model;
        _presentView.originFrame = _presentView.frame;
        [self.listView addSubview:_presentView];
        
        [self.presentView animateWithCompleteBlock:^(BOOL finished,NSInteger finishCount) {
            self.finished = finished;
            self.finishedBlock(finished,finishCount);
        }];
    }];
    
}

// 右边动画添加到队列
-(void) addOperationWithPightAnimView{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _rightAnimView.model = _model;
        _rightAnimView.originFrame = _rightAnimView.frame;
        [self.rightAnimlistView addSubview:_rightAnimView];
        
        [self.rightAnimView animateWithCompleteBlock:^(BOOL finished,NSInteger finishCount) {
            self.finished = finished;
            self.finishedBlock(finished,finishCount);
        }];
    }];
}

// 海洋之星动画添加到队列
-(void)addOperationWithOceanAnimView{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _oceanAnimView.model = _model;
        _oceanAnimView.originFrame = _oceanAnimView.frame;
        [self.oceanAnimlistView addSubview:_oceanAnimView];
        
        [self.oceanAnimView animateWithCompleteBlock:^(BOOL finished,NSInteger finishCount) {
            self.finished = finished;
            self.finishedBlock(finished,finishCount);
        }];
    }];
    
}

// 女皇的城堡动画添加到队列
-(void)addOperationWithCastleAnimView{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _castleAnimView.model = _model;
        _castleAnimView.originFrame = _castleAnimView.frame;
        [self.castleAnimlistView addSubview:_castleAnimView];
        
        [self.castleAnimView animateWithCompleteBlock:^(BOOL finished,NSInteger finishCount) {
            self.finished = finished;
            self.finishedBlock(finished,finishCount);
        }];
    }];
    
}

// 贵族面具动画添加到队列
-(void)addOperationWithMarkAnimView{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _markAnimView.model = _model;
        _markAnimView.originFrame = _markAnimView.frame;
        [self.markAnimlistView addSubview:_markAnimView];
        
        [self.markAnimView animateWithCompleteBlock:^(BOOL finished,NSInteger finishCount) {
            self.finished = finished;
            self.finishedBlock(finished,finishCount);
        }];
    }];
    
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}


@end
