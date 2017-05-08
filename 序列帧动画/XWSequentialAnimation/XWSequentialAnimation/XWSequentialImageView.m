//
//  XWSequentialImageView.m
//  XWSequentialAnimation
//
//  Created by 邱学伟 on 2017/5/7.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWSequentialImageView.h"

@interface XWSequentialImageView ()

@property (nonatomic, assign) NSUInteger imagesCount;
@property (nonatomic, assign) NSUInteger imageAnimationDuration;
@property (nonatomic, copy) NSString *imageName;

// 定义一个字典存放序列帧数组

//判断是横屏竖屏
#define iSLandscapeRight [UIApplication sharedApplication].statusBarOrientation != UIDeviceOrientationPortrait ? YES : NO

@end

@implementation XWSequentialImageView


/**
 展示序列帧动画

 @param imageName 图片名称
 @param imagesCount 图片数量
 @param imageAnimationDuration 动画执行时间
 */
- (void)showSequentialImagesWithImageName:(NSString *)imageName imagesCount:(NSUInteger)imagesCount imageAnimationDuration:(NSUInteger)imageAnimationDuration {
    if (iSLandscapeRight) {
        self.contentMode = UIViewContentModeBottom;
    }else{
        self.contentMode = UIViewContentModeScaleToFill;
    }
    self.clipsToBounds = YES;
    self.imageName = imageName;
    self.imagesCount = imagesCount;
    self.imageAnimationDuration = imageAnimationDuration;
    self.animationImages = [self sequentialImagesWithImageName:imageName imagesCount:imagesCount];// 序列帧动画的uiimage数组
    self.animationDuration = self.imageAnimationDuration;// 序列帧全部播放完所用时间
    self.animationRepeatCount = 1;// 序列帧动画重复次数
    [self startAnimating];//开始动画
//    [self performSelector:@selector(clearAinimationImageMemory) withObject:nil afterDelay:self.imageAnimationDuration];/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.imageAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clearAinimationImageMemory];
    });
}
// 清除animationImages所占用内存
- (void)clearAinimationImageMemory {
    [self stopAnimating];
    self.animationImages = nil;
}


- (NSArray *)sequentialImagesWithImageName:(NSString *)imageName imagesCount:(NSUInteger)imagesCount{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    if (imageArray.count == 0) {
        NSString *bundlePath = [NSBundle mainBundle].bundlePath;
        for (int i = 1; i <= imagesCount; i++) {
            NSString *imagePath = [[NSString alloc] init];
            if (i <= 9) {
                imagePath = [NSString stringWithFormat:@"%@/%@0%zd@2x.png",bundlePath,imageName,i];
            }else{
                imagePath = [NSString stringWithFormat:@"%@/%@%zd@2x.png",bundlePath,imageName,i];
            }
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



@end
