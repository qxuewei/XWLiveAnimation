//
//  XWLiveGiftAnimationHeader.h
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#ifndef XWLiveGiftAnimationHeader_h
#define XWLiveGiftAnimationHeader_h


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#import "UIColor+XWColor.h"
#import "XWGiftModel.h"
#import "XWAnimOperation.h"
#import "XWShakeLabel.h"
#import "XWAnimOperationManager.h"
#import "UIView+XWAnimate.h"
#import "XWAnimationImageCache.h"

#import "XWBaseAnimView.h"
#import "XWPresentView.h"
#import "XWRightAnimView.h"
//#import "XWOceanAnimView.h"
//#import "XWMarkAnimView.h"


#define KLivePresentViewWidth 200.0
#define KLivePresentViewHight 30.0
#define KLivePresentViewWidthSpace 10.0

#define kLiveQueue2FooterSpace ( 275.0)   //如需适配横屏需要在此处修改
#define kLiveQueue2OriginY (SCREEN_HEIGHT - kLiveQueue2FooterSpace - KLivePresentViewHight)
#define kLiveQueue1OriginY (SCREEN_HEIGHT - kLiveQueue2FooterSpace - KLivePresentViewHight*2 - KLivePresentViewWidthSpace*2)


#define KGiftImageViewWidth 50.0

#define KLiveShakeLabelWidth 70.0
#define KLiveShakeLabelHight 27.0

#define KLiveShakeLabelMaxNum 999 //最大数为999

#define KAnimUpToDownHight  10  //所有动画上下往返运动

#define KLiveRightAnimViewWidth  198.0
#define KLiveRightAnimViewHight  56.0
#define KLiveRightAnimViewFooterSpace 253.0
#define KLiveRightAnimViewWidthSpace 12.0
#define KLiveRightAnimViewLabelVarSpace 10.0
#define KLiveRightAnimViewLabelSpace 15.0
#define KLiveRightAnimViewLabelWidth (KLiveRightAnimViewWidth - KLiveRightAnimViewLabelSpace - KLiveRightAnimViewWidthSpace)
#define KLiveRightAnimViewLabelHight (KLiveRightAnimViewHight - KLiveRightAnimViewLabelVarSpace*2)/2
#define KLiveRightAnimViewWidthOriginX  (SCREEN_WIDTH - KLiveRightAnimViewWidth)
#define KLiveRightAnimViewWidthOriginY  (SCREEN_HEIGHT - KLiveRightAnimViewFooterSpace - KLiveRightAnimViewHight)
#define KLiveRightAnimViewShakeNumberLabelVarSpace 15
#define KLiveRightAnimViewLoveWidth 145.0
#define KLiveRightAnimViewLoveHight 110.0

#define KLiveCoffeeCupImageViewWidth 110.0
#define KLiveCoffeeCupImageViewHight 62.0
#define KLiveCoffeeCupImageViewWidthSpace 26.0
#define KLiveCoffeeCupImageViewHightSpace 16.0

//用户打赏动画
#define KAnimNameLabelLeftSPace   55
#define KAnimMameLabelTopSPace    18
#define KAnimNameLabelFooterSPace   12

#define KUserInfoAnimViewWidth  277
#define KUserInfoAnimViewHight  62.5
#define KUserInfoAnimViewHightFooterSpace  333




#endif /* XWLiveGiftAnimationHeader_h */
