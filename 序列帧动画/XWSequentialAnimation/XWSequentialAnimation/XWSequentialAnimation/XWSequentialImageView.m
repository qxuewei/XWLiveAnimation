//
//  XWSequentialImageView.m
//  XWSequentialAnimation
//
//  Created by 邱学伟 on 2017/5/7.
//  Copyright © 2017年 邱学伟. All rights reserved.
//
/*
 三处优化细节:
 1. 初始化序列帧图片使用 imageWithContentsOfFile 不会添加缓存，重复使用会占用多次内存，但使用完会回收；imageNamed 添加缓存，但使用完不释放
 2. 对播放过的序列帧进行缓存
 3. 播放完成之后做一次清楚操作
 */

#import "XWSequentialImageView.h"
#import "XWSequentialImageModel.h"

//判断是横屏竖屏
#define iSLandscapeRight [UIApplication sharedApplication].statusBarOrientation != UIDeviceOrientationPortrait ? YES : NO

@interface XWSequentialImageView ()
@property (nonatomic, copy) XWSequentialImageViewCompletionBlock completionBlock;
@property (nonatomic, assign) NSUInteger imagesCount;
@property (nonatomic, assign) NSUInteger imageAnimationDuration;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) BOOL isShow;
// 动画操作数据
@property (nonatomic, strong) NSMutableArray *showSequentialAnimationImagesQueueArrM;
// 缓存序列帧图片数组
@property (nonatomic, strong) NSCache *showSequentialAnimationImagesCache;
// 播放队列
@property (nonatomic, strong) NSOperationQueue *showSequentialAnimationImagesQueue;

@end

@implementation XWSequentialImageView

#pragma mark - public
/**
 展示序列帧动画
 
 @param sequentialImageModel 序列帧动画模型
 */
- (void)showSequentialImagesWithSequentialImageMode:(XWSequentialImageModel *)sequentialImageModel WithCompletion:(XWSequentialImageViewCompletionBlock)completion{
    if (completion) {
        self.completionBlock = completion;
    }
    [self.showSequentialAnimationImagesQueueArrM addObject:sequentialImageModel];
    if (!_isShow) {
        [self showSequentialAnimationImagesQueueAddOperation];
    }
}

#pragma mark - private
- (void)showSequentialAnimationImagesQueueAddOperation {
    if (self.showSequentialAnimationImagesQueueArrM.count > 0 && !_isShow) {
        XWSequentialImageModel *sequentialImageModel = [self.showSequentialAnimationImagesQueueArrM firstObject];
        NSBlockOperation *q = [NSBlockOperation blockOperationWithBlock:^{
            [self xw_showSequentialImagesWithSequentialImageMode:sequentialImageModel];
        }];
        [self.showSequentialAnimationImagesQueue addOperation:q];
    }else {
        if (self.completionBlock) {
            self.completionBlock(YES);
        }
    }
}

- (void)xw_showSequentialImagesWithSequentialImageMode:(XWSequentialImageModel *)sequentialImageModel {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (iSLandscapeRight) {
            self.contentMode = UIViewContentModeBottom;
        }else{
            self.contentMode = UIViewContentModeScaleToFill;
        }
        // 序列帧动画的uiimage数组
        NSArray *animationImages = [self.showSequentialAnimationImagesCache objectForKey:sequentialImageModel.sequentialImageName];
        self.imageName = sequentialImageModel.sequentialImageName;
        self.imagesCount = sequentialImageModel.sequentialImagesCount.integerValue;
        self.imageAnimationDuration = sequentialImageModel.sequentialImageAnimationDuration.integerValue;
        if (animationImages.count == 0) {
            animationImages = [self sequentialImagesWithImageName:self.imageName imagesCount:self.imagesCount];
            [self.showSequentialAnimationImagesCache setObject:animationImages forKey:sequentialImageModel.sequentialImageName];
        }
        self.animationImages = animationImages;
        self.animationDuration = self.imageAnimationDuration;// 序列帧全部播放完所用时间
        self.animationRepeatCount = 1;// 序列帧动画重复次数
        [self startAnimating];//开始动画
        if (self.showSequentialAnimationImagesQueueArrM.count > 0) {
            [self.showSequentialAnimationImagesQueueArrM removeObjectAtIndex:0];
        }
        _isShow = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.imageAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self clearAinimationImageMemory];
        });

    }];
}

// 清除animationImages所占用内存
- (void)clearAinimationImageMemory {
    _isShow = NO;
    [self stopAnimating];
    self.animationImages = nil;
    [self showSequentialAnimationImagesQueueAddOperation];
}


/// 读取图片
- (NSArray *)sequentialImagesWithImageName:(NSString *)imageName imagesCount:(NSUInteger)imagesCount{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    if (imageArray.count == 0) {
        NSString *bundlePath = [NSBundle mainBundle].bundlePath;
        for (int i = 0; i < imagesCount; i++) {
            NSString *imagePath = [[NSString alloc] init];
//            if (i <= 9) {
//                imagePath = [NSString stringWithFormat:@"%@/%@0%zd@2x.png",bundlePath,imageName,i];
//            }else{
//                imagePath = [NSString stringWithFormat:@"%@/%@%zd@2x.png",bundlePath,imageName,i];
//            }
            imagePath = [NSString stringWithFormat:@"%@/%@%zd.png",bundlePath,imageName,i];
            UIImage *image = [XWSequentialImageView scaleImage:[UIImage imageWithContentsOfFile:imagePath]];
            [imageArray addObject:image];
        }
    }
    return imageArray.copy;
}

/// 等比例缩放图片
+ (UIImage *)scaleImage:(UIImage *)image {
    CGFloat originW = image.size.width;
    CGFloat originH = image.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat w = screenH > screenW ? screenH : screenW;
    CGFloat h = w * originH / originW;
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [image drawInRect:CGRectMake(0, 0, w, h)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - setter/getter
- (NSCache *)showSequentialAnimationImagesCache {
    if(!_showSequentialAnimationImagesCache){
        _showSequentialAnimationImagesCache = [[NSCache alloc] init];
    }
    return _showSequentialAnimationImagesCache;
}

- (NSOperationQueue *)showSequentialAnimationImagesQueue {
    if(!_showSequentialAnimationImagesQueue){
        _showSequentialAnimationImagesQueue = [[NSOperationQueue alloc] init];
        _showSequentialAnimationImagesQueue.name = @"showSequentialAnimationImagesQueue";
        _showSequentialAnimationImagesQueue.maxConcurrentOperationCount = 3;
    }
    return _showSequentialAnimationImagesQueue;
}

- (NSMutableArray *)showSequentialAnimationImagesQueueArrM {
    if(!_showSequentialAnimationImagesQueueArrM){
        _showSequentialAnimationImagesQueueArrM = [[NSMutableArray alloc] init];
    }
    return _showSequentialAnimationImagesQueueArrM;
}

@end
