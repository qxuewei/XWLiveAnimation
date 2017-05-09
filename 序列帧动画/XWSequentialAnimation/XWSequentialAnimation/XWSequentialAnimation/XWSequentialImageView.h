//
//  XWSequentialImageView.h
//  XWSequentialAnimation
//
//  Created by 邱学伟 on 2017/5/7.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWSequentialImageModel;

typedef void(^XWSequentialImageViewCompletionBlock)(BOOL animationFinished);

@interface XWSequentialImageView : UIImageView
/**
 展示序列帧动画
 
 @param sequentialImageModel 序列帧动画模型
 */
- (void)showSequentialImagesWithSequentialImageMode:(XWSequentialImageModel *)sequentialImageModel WithCompletion:(XWSequentialImageViewCompletionBlock)completion;
@end
