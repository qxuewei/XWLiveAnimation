//
//  XWRightAnimView.m
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/29.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWRightAnimView.h"
#import "XWLiveGiftAnimationHeader.h"

@interface XWRightAnimView ()

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *loveAnimateView;
@property (nonatomic,strong) UIImageView *hotGasAnimateView;  //热气
@property (nonatomic,strong) UIImageView *coffeeCupImageView; //杯子
@property (nonatomic,strong) XWGiftModel *giftModel;

@end

@implementation XWRightAnimView

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(void)setupCustomView{
    
    _bgImageView = [[UIImageView alloc] init];
    
    //爱心动画
    _loveAnimateView = [[UIImageView alloc] init];
    
    //热气动画
    _hotGasAnimateView  = [[UIImageView alloc] init];
    _coffeeCupImageView = [[UIImageView alloc] init];
    
    [self addSubview:_bgImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.giftLabel];
    [self addSubview:self.skLabel];
    [self addSubview:_loveAnimateView];
    [self addSubview:_coffeeCupImageView];
    [_coffeeCupImageView addSubview:_hotGasAnimateView];
}

/**
 * 公共视图初始化
 **/
-(void)pubicView{
    
    ;
}

#pragma mark 布局 UI
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    self.nameLabel.frame = CGRectMake(KLiveRightAnimViewLabelSpace, KLiveRightAnimViewLabelVarSpace, KLiveRightAnimViewLabelWidth, KLiveRightAnimViewLabelHight);
    self.giftLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, KLiveRightAnimViewLabelHight+KLiveRightAnimViewLabelVarSpace, KLiveRightAnimViewLabelWidth, KLiveRightAnimViewLabelHight);
    
    self.bgImageView.frame = self.bounds;
    _bgImageView.frame = CGRectMake(0, 0, self.frame.size.width - KLiveRightAnimViewWidthSpace, self.frame.size.height);
    _bgImageView.image = [[XWAnimationImageCache shareInstance] getImageWithName:@"bg_backgroundcolor_14th"];
    
    _loveAnimateView.frame = CGRectMake(0,-KLiveRightAnimViewLoveHight+KLiveRightAnimViewLabelVarSpace*2, KLiveRightAnimViewLoveWidth,KLiveRightAnimViewLoveHight);
    self.skLabel.frame = CGRectMake(self.frame.size.width - KLiveShakeLabelWidth,-KLiveRightAnimViewShakeNumberLabelVarSpace-KLiveShakeLabelHight, KLiveShakeLabelWidth, KLiveShakeLabelHight);
    
    _coffeeCupImageView.frame = CGRectMake(0,-KLiveRightAnimViewLoveHight+KLiveRightAnimViewLabelVarSpace*2,KLiveRightAnimViewLoveWidth,KLiveRightAnimViewLoveHight);
    _hotGasAnimateView.frame  = CGRectMake(KLiveCoffeeCupImageViewWidthSpace,KLiveCoffeeCupImageViewHightSpace,KLiveCoffeeCupImageViewWidth,KLiveCoffeeCupImageViewHight);
}

#pragma mark - 对外接口

- (void)setModel:(XWGiftModel *)model {
    
    _giftModel = model;
    
    NSString *nameLabelStr = [NSString stringWithFormat:@"感谢%@",model.user.userName];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:nameLabelStr];
    NSRange rangeStr = [nameLabelStr rangeOfString:[NSString stringWithFormat:@"%@",model.user.userName]];
    [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x00ff00] range:rangeStr];
    self.nameLabel.attributedText = attstr;
    
    NSString *giftLabelStr = [NSString stringWithFormat:@"送出的【%@】",model.giftName];
    NSMutableAttributedString *giftattstr = [[NSMutableAttributedString alloc]initWithString:giftLabelStr];
    NSRange giftrangeStr = [giftLabelStr rangeOfString:[NSString stringWithFormat:@"【%@】",model.giftName]];
    [giftattstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x00eaff] range:giftrangeStr];
    self.giftLabel.attributedText = giftattstr;
    self.giftCount = model.giftCount;
    
}


- (void)animateWithCompleteBlock:(completeBlock)completed{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(KLiveRightAnimViewWidthOriginX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
        if (_giftModel.giftType == GIFT_TYPE_COOFFEE) {
            [self showOffeeAnim];
        }else if (_giftModel.giftType == GIFT_TYPE_GUARD){
            [self showLoveAnim];
        }
        
    }];
    self.completeBlock = completed;
    
}

//爱心动画
-(void)showLoveAnim{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self startLoveAnimating];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self shakeNumberLabel];
        });
    }];
}

//咖啡动画
-(void)showOffeeAnim{
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self startOffeeAnimating];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self shakeNumberLabel];
        });
    }];
    
}


/// 自定义隐藏动画 - 子类重写
- (void)hideCurretView{
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(SCREEN_WIDTH, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.completeBlock) {
            self.completeBlock(finished,self.animCount);
        }
        [self resetframe];
        self.finished = finished;
        [self removeFromSuperview];
    }];
    
}


/**
 * @brief 开始动画
 */
- (void)startLoveAnimating
{
    
    [UIView downUpAnimation:self.loveAnimateView
      withAnimUpToDownHight:KLiveRightAnimViewLabelVarSpace*2
               withDuration:0.5
            withRepeatCount:1];
    
    NSArray *magesArray = [NSArray arrayWithObjects:
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_heart_1_14th"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_heart_2_14th"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_heart_3_14th"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_heart_4_14th"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_heart_5_14th"],nil];
    _loveAnimateView.animationImages = magesArray;//将序列帧数组赋给UIImageView的animationImages属性
    _loveAnimateView.animationDuration = 0.5;//设置动画时间
    _loveAnimateView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    [_loveAnimateView startAnimating];//开始播放动画
    
    //延时结束刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_loveAnimateView stopAnimating];
    });
    
}

// 开始offee动画
- (void)startOffeeAnimating {
    //
    [UIView downUpAnimation:self.coffeeCupImageView
      withAnimUpToDownHight:KLiveRightAnimViewLabelVarSpace*2
               withDuration:0.5
            withRepeatCount:1];
    
    //热气动画
    NSArray *magesArray = [NSArray arrayWithObjects:
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_1"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_2"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_3"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_4"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_5"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_6"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_7"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_8"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_9"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_10"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_11"],
                           [[XWAnimationImageCache shareInstance] getImageWithName:@"ic_fogmov_14th_12"],nil];
    _coffeeCupImageView.animationImages = magesArray;//将序列帧数组赋给UIImageView的animationImages属性
    _coffeeCupImageView.animationDuration = 1.6;//设置动画时间
    _coffeeCupImageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    [_coffeeCupImageView startAnimating];//开始播放动画
    
    //延时结束刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        [_coffeeCupImageView stopAnimating];
    });
    
}

// 热气动画
-(void)hotGasAnimation{
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _hotGasAnimateView.center  = CGPointMake(_hotGasAnimateView.center.x-10,_hotGasAnimateView.center.y-10);
        _hotGasAnimateView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _hotGasAnimateView.center  = CGPointMake(_hotGasAnimateView.center.x-10,_hotGasAnimateView.center.y-10);
            _hotGasAnimateView.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _hotGasAnimateView.center  = CGPointMake(_hotGasAnimateView.center.x-10,_hotGasAnimateView.center.y-10);
                _hotGasAnimateView.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                [self hotGasAnimation];
            }];
        }];
        
    }];
    
    
}



@end
