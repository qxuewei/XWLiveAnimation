//
//  XWPresentView.m
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWPresentView.h"
#import "XWLiveGiftAnimationHeader.h"

@interface XWPresentView ()

@property (nonatomic,strong) UIImageView *bgImageView;

@end

@implementation XWPresentView

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(void)setupCustomView{
    
    self.nameLabel.textColor  = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    
    self.giftLabel.textColor  = [UIColor colorWithHex:0x3ae3fa];
    self.giftLabel.font = [UIFont systemFontOfSize:12];
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _headImageView = [[UIImageView alloc] init];
    _giftImageView = [[UIImageView alloc] init];
    
    
    [self addSubview:_bgImageView];
    [self addSubview:_headImageView];
    [self addSubview:_giftImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.giftLabel];
    [self addSubview:self.skLabel];
    
    
}

-(void)pubicView{
    ;
}

#pragma mark 布局 UI
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _headImageView.frame = CGRectMake(KLivePresentViewWidthSpace + KLivePresentViewDistanceSpace, KLivePresentViewDistanceSpace, self.frame.size.height - KLivePresentViewDistanceSpace * 2, self.frame.size.height - KLivePresentViewDistanceSpace * 2);
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height * 0.5;
    _headImageView.layer.masksToBounds = YES;
    
    
    self.nameLabel.frame = CGRectMake(_headImageView.frame.size.width + KLivePresentViewWidthSpace*2, 0, KLivePresentViewWidth - KGiftImageViewWidth - self.frame.size.height, self.frame.size.height/2);
    self.giftLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.headImageView.frame) - self.frame.size.height/2-2, self.nameLabel.frame.size.width, self.frame.size.height/2);
    
    _bgImageView.layer.cornerRadius = self.frame.size.height * 0.5;
    _bgImageView.layer.masksToBounds = YES;
    
    _bgImageView.frame = CGRectMake(KLivePresentViewWidthSpace, 0, 200, self.frame.size.height);
    _giftImageView.frame = CGRectMake(CGRectGetMaxX(_bgImageView.frame), self.frame.size.height - KGiftImageViewWidth, KGiftImageViewWidth, KGiftImageViewWidth);
    self.skLabel.frame = CGRectMake(CGRectGetMaxX(_giftImageView.frame),self.frame.size.height-KLiveShakeLabelHight, KLiveShakeLabelWidth, KLiveShakeLabelHight);
    
}

#pragma mark - 对外接口

- (void)setModel:(XWGiftModel *)model {
    
    self.nameLabel.text = model.user.userName;
    self.giftLabel.text = [NSString stringWithFormat:@"%@",model.giftName];
    self.giftCount = model.giftCount;
    
    _headImageView.image = model.headImage;
    _giftImageView.image = model.giftImage;
    
    
}

- (void)setupCustomViewFrameWithWidth:(CGFloat)width {
    
}

- (void)animateWithCompleteBlock:(completeBlock)completed{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self shakeNumberLabel];
    }];
    self.completeBlock = completed;
}

- (void)giftImageMoveAnimation {
    
}

/// 自定义隐藏动画 - 子类重写
- (void)hideCurretView{
    
    [UIView animateWithDuration:0.30 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
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


@end
