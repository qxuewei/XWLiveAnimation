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

//@property (nonatomic, strong) NSArray *sequentialImages;

@end

@implementation XWSequentialImageView


/**
 展示序列帧动画

 @param imageName 图片名称
 @param imagesCount 图片数量
 @param imageAnimationDuration 动画执行时间
 */
- (void)showSequentialImagesWithImageName:(NSString *)imageName imagesCount:(NSUInteger)imagesCount imageAnimationDuration:(NSUInteger)imageAnimationDuration {
    self.imageName = imageName;
    self.imagesCount = imagesCount;
    self.imageAnimationDuration = imageAnimationDuration;
    self.animationImages = [self sequentialImagesWithImageName:imageName imagesCount:imagesCount];// 序列帧动画的uiimage数组
    self.animationDuration = self.imageAnimationDuration;// 序列帧全部播放完所用时间
    self.animationRepeatCount = 1;// 序列帧动画重复次数
    [self startAnimating];//开始动画
    [self performSelector:@selector(clearAinimationImageMemory) withObject:nil afterDelay:self.imageAnimationDuration];// 性能优化的重点来了，此处我在执行完序列帧以后我执行了一个清除内存的操作
}
// 清除animationImages所占用内存
- (void)clearAinimationImageMemory {
    [self stopAnimating];
    self.animationImages = nil;
}


-(NSArray *)sequentialImagesWithImageName:(NSString *)imageName imagesCount:(NSUInteger)imagesCount{
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
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            [imageArray addObject:image];
        }
    }
    return imageArray.copy;
}

@end
