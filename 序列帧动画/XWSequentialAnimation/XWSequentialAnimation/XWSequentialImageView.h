//
//  XWSequentialImageView.h
//  XWSequentialAnimation
//
//  Created by 邱学伟 on 2017/5/7.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWSequentialImageView : UIImageView
/**
 展示序列帧动画
 
 @param imageName 图片名称
 @param imagesCount 图片数量
 @param imageAnimationDuration 动画执行时间
 */
- (void)showSequentialImagesWithImageName:(NSString *)imageName imagesCount:(NSUInteger)imagesCount imageAnimationDuration:(NSUInteger)imageAnimationDuration;
@end
