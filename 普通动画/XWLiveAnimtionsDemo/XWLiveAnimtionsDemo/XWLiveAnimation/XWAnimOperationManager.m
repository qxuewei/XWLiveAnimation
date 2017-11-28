//
//  XWAnimOperationManager.m
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWAnimOperationManager.h"
#import "XWLiveGiftAnimationHeader.h"

@interface XWAnimOperationManager ()

/// 普通动画队列1
@property (nonatomic,strong) NSOperationQueue *queue1;
/// 普通动画队列2
@property (nonatomic,strong) NSOperationQueue *queue2;

/// 从右边动画队列
@property (nonatomic,strong) NSOperationQueue *rightQueue;

/// 贵族面具动画队列
@property (nonatomic,strong) NSOperationQueue *markQueue;
/// 海洋之星动画队列
@property (nonatomic,strong) NSOperationQueue *oceanQueue;
/// 女皇的城堡动画队列
@property (nonatomic,strong) NSOperationQueue *castleQueue;

/// 礼物操作缓存池
@property (nonatomic,strong) NSCache *operationCache;

/// 维护礼物信息的同一用户同一个类型的礼物 - 缓存该用户所送礼物数量
@property (nonatomic,strong) NSCache *userGiftInfos;



@end

@implementation XWAnimOperationManager

#pragma mark - public
/// 动画操作
- (void)animWithGiftModel:(XWGiftModel *)model finishedBlock:(void(^)(BOOL result))finishedBlock {
    
    //必须要有发送礼物用户信息和礼物个数
    if (model.giftCount == 0 && model.user.userId == 0 && model.giftId == 0) {
        NSLog(@"必须要有发送礼物用户信息和礼物个数");
        finishedBlock(NO);
        return;
    }
    
    if (model.user.userName.length == 0) {
        NSLog(@"发送礼物者的名字不能为空");
        finishedBlock(NO);
        return;
    }
    
    if (model.giftType == GIFT_TYPE_DEFAULT && model.giftPic.length == 0) {
        NSLog(@"当是普通动画的时候，需要带上礼物的头像");
        finishedBlock(NO);
        return;
    }
    
    if (model.giftType == GIFT_TYPE_DEFAULT) { //普通动画
        [self animPresentView:model finishedBlock:^(BOOL result) {
            finishedBlock(result);
        }];
        
    }
    /*
    else if (model.giftType == GIFT_TYPE_GUARD) { //爱心守护者
        
        [self animWithGuard:model finishedBlock:^(BOOL result) {
            finishedBlock(result);
        }];

    }else if (model.giftType == GIFT_TYPE_MASK) {  //贵族面具
        
        [self animWithMask:model finishedBlock:^(BOOL result) {
            finishedBlock(result);
        }];

    }else if (model.giftType == GIFT_TYPE_OCEAN) { //海洋之星
        
        [self animWithOcean:model finishedBlock:^(BOOL result) {
            finishedBlock(result);
        }];
        
    }else if (model.giftType == GIFT_TYPE_COOFFEE) { //咖啡印记
        
        [self animWithCooffee:model finishedBlock:^(BOOL result) {
            finishedBlock(result);
        }];

    }else if (model.giftType == GIFT_TYPE_CASTLE) { //女皇的城堡
        
        [self animWithCastle:model finishedBlock:^(BOOL result) {
            finishedBlock(result);
        }];
    }
     */

}

/// 取消上一次的动画操作
- (void)cancelOperationWithLastGift:(XWGiftModel *)model {
    
    // 当上次为空时就不执行取消操作 (第一次进入执行时才会为空)
    if (model.user.userId > 0) {
        NSString *userReuseIdentifierID = [self getUserReuseIdentifierID:model];
        [[self.operationCache objectForKey:userReuseIdentifierID] cancel];
    }
}

//// 获得用户唯一标示reuseIdentifier，记录礼物信息的标示信息
- (NSString *)getUserReuseIdentifierID:(XWGiftModel *)model {
    
    NSString *userReuseIdentifierID = [NSString stringWithFormat:@"%ld_%ld",model.user.userId,(long)model.giftType];
    return userReuseIdentifierID;
}


#pragma mark - private
/**
 普通动画
 
 @param model 礼物模型
 */
-(void)animPresentView:(XWGiftModel *)model  finishedBlock:(void(^)(BOOL result))finishedBlock{
    
    NSString *userReuseIdentifierID = [self getUserReuseIdentifierID:model];
    // 在有用户礼物信息时
    if ([[self.userGiftInfos objectForKey:userReuseIdentifierID] integerValue] > 0) {
        // 如果有操作缓存，则直接累加，不需要重新创建op
        if ([self.operationCache objectForKey:userReuseIdentifierID]!=nil) {
            XWAnimOperation *op = [self.operationCache objectForKey:userReuseIdentifierID];
            op.presentView.giftCount = model.giftCount;
            [op.presentView shakeNumberLabel];
            return;
        }
        // 没有操作缓存，创建op
        XWAnimOperation *op = [XWAnimOperation animOperationWithGiftModel:model finishedBlock:^(BOOL result,NSInteger finishCount) {
            // 回调
            if (finishedBlock) {
                finishedBlock(result);
            }
            // 将礼物信息数量存起来
            [self.userGiftInfos setObject:@(finishCount) forKey:userReuseIdentifierID];
            // 动画完成之后,要移除动画对应的操作
            [self.operationCache removeObjectForKey:userReuseIdentifierID];
            // 延时删除用户礼物信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGiftInfos removeObjectForKey:userReuseIdentifierID];
            });
            
        }];

        // 注意：下面两句代码是和无用户礼物信息时不同的，其余的逻辑一样
        op.presentView.animCount = [[self.userGiftInfos objectForKey:userReuseIdentifierID] integerValue];
        op.model.giftCount = op.presentView.animCount + 1;
        
        op.listView = self.parentView;
        op.index = [userReuseIdentifierID integerValue] % 2;
        
        // 将操作添加到缓存池
        [self.operationCache setObject:op forKey:userReuseIdentifierID];
        
        // 根据用户ID 控制显示的位置
        if (op.index == GIFT_INDEX_queue2) {
            
            if (op.model.giftCount != 0) {
                op.presentView.frame  = CGRectMake(-KLivePresentViewWidth, kLiveQueue2OriginY, KLivePresentViewWidth, KLivePresentViewHight);
                op.presentView.originFrame = op.presentView.frame;
                [self.queue2 addOperation:op];
            }
        }else {
            
            if (op.model.giftCount != 0) {
                op.presentView.frame  = CGRectMake(-KLivePresentViewWidth, kLiveQueue1OriginY, KLivePresentViewWidth, KLivePresentViewHight);
                op.presentView.originFrame = op.presentView.frame;
                [self.queue1 addOperation:op];
            }
        }
    }
    
    // 在没有用户礼物信息时
    else
    {   // 如果有操作缓存，则直接累加，不需要重新创建op
        if ([self.operationCache objectForKey:userReuseIdentifierID]!=nil) {
            XWAnimOperation *op = [self.operationCache objectForKey:userReuseIdentifierID];
            op.presentView.giftCount = model.giftCount;
            [op.presentView shakeNumberLabel];
            return;
        }
        
        XWAnimOperation *op = [XWAnimOperation animOperationWithGiftModel:model finishedBlock:^(BOOL result,NSInteger finishCount) {
            // 回调
            if (finishedBlock) {
                finishedBlock(result);
            }
            // 将礼物信息数量存起来
            [self.userGiftInfos setObject:@(finishCount) forKey:userReuseIdentifierID];
            // 动画完成之后,要移除动画对应的操作
            [self.operationCache removeObjectForKey:userReuseIdentifierID];
            // 延时删除用户礼物信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGiftInfos removeObjectForKey:userReuseIdentifierID];
            });
            
        }];
        op.listView = self.parentView;
        op.index = [userReuseIdentifierID integerValue] % 2;
        // 将操作添加到缓存池
        [self.operationCache setObject:op forKey:userReuseIdentifierID];
        
        if (op.index == GIFT_INDEX_queue2) {
            
            if (op.model.giftCount != 0) {
                op.presentView.frame  = CGRectMake(-KLivePresentViewWidth, kLiveQueue2OriginY, KLivePresentViewWidth, KLivePresentViewHight);
                op.presentView.originFrame = op.presentView.frame;
                [self.queue2 addOperation:op];
            }
        }else {
            
            if (op.model.giftCount != 0) {
                op.presentView.frame  = CGRectMake(-KLivePresentViewWidth, kLiveQueue1OriginY, KLivePresentViewWidth, KLivePresentViewHight);
                op.presentView.originFrame = op.presentView.frame;
                [self.queue1 addOperation:op];
            }
        }
    }
}

/// 右边动画
- (void)animWithRightAnimView:(XWGiftModel *)model finishedBlock:(void (^)(BOOL))finishedBlock{
    
    NSString *userReuseIdentifierID = [self getUserReuseIdentifierID:model];
    
    // 在有用户礼物信息时
    if ([[self.userGiftInfos objectForKey:userReuseIdentifierID] integerValue] > 0) {
        // 如果有操作缓存，则直接累加，不需要重新创建op
        if ([self.operationCache objectForKey:userReuseIdentifierID]!=nil) {
            XWAnimOperation *op = [self.operationCache objectForKey:userReuseIdentifierID];
            op.rightAnimView.giftCount = model.giftCount;
            [op.rightAnimView shakeNumberLabel];
            return;
        }
        // 没有操作缓存，创建op
        XWAnimOperation *op = [XWAnimOperation animOperationWithGiftModel:model finishedBlock:^(BOOL result,NSInteger finishCount) {
            // 回调
            if (finishedBlock) {
                finishedBlock(result);
            }
            // 将礼物信息数量存起来
            [self.userGiftInfos setObject:@(finishCount) forKey:userReuseIdentifierID];
            // 动画完成之后,要移除动画对应的操作
            [self.operationCache removeObjectForKey:userReuseIdentifierID];
            // 延时删除用户礼物信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGiftInfos removeObjectForKey:userReuseIdentifierID];
            });
            
        }];
        
        // 注意：下面两句代码是和无用户礼物信息时不同的，其余的逻辑一样
        op.rightAnimView.animCount = [[self.userGiftInfos objectForKey:userReuseIdentifierID] integerValue];
        op.model.giftCount = op.rightAnimView.animCount + 1;
        
        op.rightAnimlistView = self.parentView;
        op.index = GIFT_INDEX_rightQueue;
        
        // 将操作添加到缓存池
        [self.operationCache setObject:op forKey:userReuseIdentifierID];
        
        // 根据用户ID 控制显示的位置
        if (op.model.giftCount != 0) {
            op.rightAnimView.frame  = CGRectMake(SCREEN_WIDTH, KLiveRightAnimViewWidthOriginY, KLiveRightAnimViewWidth, KLiveRightAnimViewHight);
            op.rightAnimView.originFrame = op.rightAnimView.frame;
            [self.rightQueue addOperation:op];
        }
    }
    
    // 在没有用户礼物信息时
    else
    {   // 如果有操作缓存，则直接累加，不需要重新创建op
        if ([self.operationCache objectForKey:userReuseIdentifierID]!=nil) {
            XWAnimOperation *op = [self.operationCache objectForKey:userReuseIdentifierID];
            op.rightAnimView.giftCount = model.giftCount;
            [op.rightAnimView shakeNumberLabel];
            return;
        }
        
        XWAnimOperation *op = [XWAnimOperation animOperationWithGiftModel:model finishedBlock:^(BOOL result,NSInteger finishCount) {
            // 回调
            if (finishedBlock) {
                finishedBlock(result);
            }
            // 将礼物信息数量存起来
            [self.userGiftInfos setObject:@(finishCount) forKey:userReuseIdentifierID];
            // 动画完成之后,要移除动画对应的操作
            [self.operationCache removeObjectForKey:userReuseIdentifierID];
            // 延时删除用户礼物信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGiftInfos removeObjectForKey:userReuseIdentifierID];
            });
            
        }];
        op.rightAnimlistView = self.parentView;
        op.index = GIFT_INDEX_rightQueue;
        // 将操作添加到缓存池
        [self.operationCache setObject:op forKey:userReuseIdentifierID];
        
        if (op.model.giftCount != 0) {
            op.rightAnimView.frame  = CGRectMake(SCREEN_WIDTH, KLiveRightAnimViewWidthOriginY, KLiveRightAnimViewWidth, KLiveRightAnimViewHight);
            op.rightAnimView.originFrame = op.rightAnimView.frame;
            [self.rightQueue addOperation:op];
        }
        
    }
    
    
}

//咖啡印记
-(void) animWithCooffee:(XWGiftModel *)model finishedBlock:(void (^)(BOOL))finishedBlock{
    [self animWithRightAnimView:model finishedBlock:^(BOOL result) {
        finishedBlock(result);
    }];
}

//爱心守护者
-(void) animWithGuard:(XWGiftModel *)model finishedBlock:(void (^)(BOOL))finishedBlock{
    [self animWithRightAnimView:model finishedBlock:^(BOOL result) {
        finishedBlock(result);
    }];
}

//贵族面具
- (void)animWithMask:(XWGiftModel *)model finishedBlock:(void (^)(BOOL))finishedBlcok {
    NSString *userReuseIdentifierID = [self getUserReuseIdentifierID:model];
    //有用户礼物信息
    if ([self.userGiftInfos objectForKey:userReuseIdentifierID]) {
        // 有操作缓存直接累加
        if ([self.operationCache objectForKey:userReuseIdentifierID]) {
            XWAnimOperation *op = [self.operationCache objectForKey:userReuseIdentifierID];
            op.markAnimView.giftCount = model.giftCount;
            [op.markAnimView shakeNumberLabel];
            return;
        }
        // 没有操作缓存
        XWAnimOperation *op = [XWAnimOperation animOperationWithGiftModel:model finishedBlock:^(BOOL result, NSInteger finishCount) {
            if (finishedBlcok) {
                finishedBlcok(result);
            }
            // 礼物数量存起来
            [self.userGiftInfos setObject:@(finishCount) forKey:userReuseIdentifierID];
            // 动画完成后移除对应的操作
            [self.operationCache removeObjectForKey:userReuseIdentifierID];
            // 延时删除用户礼物信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGiftInfos removeObjectForKey:userReuseIdentifierID];
            });
        }];
        op.markAnimView.animCount = [[self.userGiftInfos objectForKey:userReuseIdentifierID] integerValue];
        op.model.giftCount = op.markAnimView.animCount + 1;
        op.markAnimlistView = self.parentView;
        op.index = GIFT_INDEX_markQueue;
        [self.operationCache setObject:op forKey:userReuseIdentifierID];
        if (op.model.giftCount != 0) {
            op.markAnimView.frame = self.parentView.frame;
            op.markAnimView.originFrame = op.markAnimView.frame;
            [self.markQueue addOperation:op];
        }
    }
    //没有用户礼物信息
    else {
        //有操作缓存
        if ([self.operationCache objectForKey:userReuseIdentifierID]) {
            XWAnimOperation *op = [self.operationCache objectForKey:userReuseIdentifierID];
            op.markAnimView.giftCount = model.giftCount;
            [op.markAnimView shakeNumberLabel];
            return;
        }
        //没有操作缓存
        XWAnimOperation *op = [XWAnimOperation animOperationWithGiftModel:model finishedBlock:^(BOOL result, NSInteger finishCount) {
            if (finishedBlcok) {
                finishedBlcok(result);
            }
            // 将礼物信息数量缓存起来
            [self.userGiftInfos setObject:@(finishCount) forKey:userReuseIdentifierID];
            // 动画完成之后, 要移除动画对应的操作
            [self.operationCache removeObjectForKey:userReuseIdentifierID];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGiftInfos removeObjectForKey:userReuseIdentifierID];
            });
        }];
        op.markAnimlistView = self.parentView;
        op.index = GIFT_INDEX_markQueue;
        // 将操作添加缓存池
        [self.operationCache setObject:op forKey:userReuseIdentifierID];
        
        if (op.model.giftCount != 0) {
            op.markAnimView.frame = self.parentView.frame;
            op.markAnimView.originFrame = op.markAnimlistView.frame;
            [self.markQueue addOperation:op];
        }
    }
}

//海洋之星
- (void)animWithOcean:(XWGiftModel *)model finishedBlock:(void (^)(BOOL))finishedBlock {
    XWAnimOperation *op = [XWAnimOperation animOperationWithGiftModel:model finishedBlock:^(BOOL result, NSInteger finishCount) {
        if (finishedBlock) {
            finishedBlock(result);
        }
    }];
    op.oceanAnimlistView = self.parentView;
    op.index = GIFT_INDEX_oceanQueue;
    if (op.model.giftCount != 0) {
        op.markAnimView.frame = self.parentView.frame;
        op.markAnimView.originFrame = self.parentView.frame;
        [self.oceanQueue addOperation:op];
    }
}

//女皇城堡
- (void)animWithCastle:(XWGiftModel *)model finishedBlock:(void (^)(BOOL))finishedBlcok {
    XWAnimOperation *op = [XWAnimOperation animOperationWithGiftModel:model finishedBlock:^(BOOL result, NSInteger finishCount) {
        if (finishedBlcok) {
            finishedBlcok(result);
        }
    }];
    op.castleAnimlistView = self.parentView;
    op.index = GIFT_INDEX_castleQueue;
    if (op.model.giftCount != 0) {
        op.castleAnimView.frame = self.parentView.frame;
        op.castleAnimView.originFrame = self.parentView.frame;
        [self.castleQueue addOperation:op];
    }
}




#pragma mark - lazy
- (NSOperationQueue *)queue1 {
    if (_queue1==nil) {
        _queue1 = [[NSOperationQueue alloc] init];
        _queue1.maxConcurrentOperationCount = 1;
        
    }
    return _queue1;
}

- (NSOperationQueue *)queue2 {
    if (_queue2==nil) {
        _queue2 = [[NSOperationQueue alloc] init];
        _queue2.maxConcurrentOperationCount = 1;
    }
    return _queue2;
}

- (NSOperationQueue *)rightQueue {
    if (_rightQueue==nil) {
        _rightQueue = [[NSOperationQueue alloc] init];
        _rightQueue.maxConcurrentOperationCount = 1;
    }
    return _rightQueue;
}

-(NSOperationQueue *)markQueue{
    
    if (_markQueue==nil) {
        _markQueue = [[NSOperationQueue alloc] init];
        _markQueue.maxConcurrentOperationCount = 1;
    }
    return _markQueue;
}

-(NSOperationQueue *)oceanQueue{
    
    if (_oceanQueue==nil) {
        _oceanQueue = [[NSOperationQueue alloc] init];
        _oceanQueue.maxConcurrentOperationCount = 1;
    }
    return _oceanQueue;
}


-(NSOperationQueue *)castleQueue{
    
    if (_castleQueue==nil) {
        _castleQueue = [[NSOperationQueue alloc] init];
        _castleQueue.maxConcurrentOperationCount = 1;
    }
    return _castleQueue;
}
- (NSCache *)operationCache {
    if (_operationCache==nil) {
        _operationCache = [[NSCache alloc] init];
    }
    return _operationCache;
}

- (NSCache *)userGiftInfos {
    if (_userGiftInfos == nil) {
        _userGiftInfos = [[NSCache alloc] init];
    }
    return _userGiftInfos;
}


-(void)resetDealloc {
    
    if (_queue1 != nil) {
        _queue1 = nil;
    }
    
    if (_queue2 != nil) {
        _queue2 = nil;
    }
    
    if (_rightQueue!= nil) {
        _rightQueue = nil;
    }
    
    if (_markQueue!= nil) {
        _markQueue = nil;
    }
    
    if (_oceanQueue!= nil) {
        
        _oceanQueue = nil;
    }
    
    if (_castleQueue!=nil) {
        _castleQueue = nil;
    }
    
    if (_operationCache != nil) {
        _operationCache = nil;
    }
    
    if (_userGiftInfos != nil) {
        _userGiftInfos = nil;
    }
    
    
    if (_parentView != nil) {
        _parentView = nil;  
    }
}

//释放内存
-(void)dealloc{
    [self resetDealloc];  
}

/// 单例对象
static XWAnimOperationManager *_defaultManager;
#pragma mark - 单例对象
+ (instancetype)shareInstance {
    
    if (!_defaultManager) {
        _defaultManager = [[self alloc] init];
    }
    return _defaultManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (!_defaultManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _defaultManager = [super allocWithZone:zone];
        });
    }
    return _defaultManager;
}

- (id)copyWithZone:(NSZone *)zone{
    
    return _defaultManager;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    
    return _defaultManager;
}

@end
