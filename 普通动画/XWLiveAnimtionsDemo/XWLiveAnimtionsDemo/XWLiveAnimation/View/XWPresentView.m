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
    
    self.giftLabel.textColor  = [UIColor colorWithHex:0x00eaff];
    self.giftLabel.font = [UIFont systemFontOfSize:12];
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor blackColor];
    _bgImageView.alpha = 0.3;
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
    
    _headImageView.frame = CGRectMake(KLivePresentViewWidthSpace, 0, self.frame.size.height, self.frame.size.height);
    _headImageView.layer.cornerRadius = self.frame.size.height / 2;
    _headImageView.layer.masksToBounds = YES;
    
    _giftImageView.frame = CGRectMake(self.frame.size.width - KGiftImageViewWidth + KLivePresentViewWidthSpace, self.frame.size.height - KGiftImageViewWidth, KGiftImageViewWidth, KGiftImageViewWidth);
    
    self.nameLabel.frame = CGRectMake(_headImageView.frame.size.width + KLivePresentViewWidthSpace*2, 0, KLivePresentViewWidth - KGiftImageViewWidth - self.frame.size.height, self.frame.size.height/2);
    self.giftLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.headImageView.frame) - self.frame.size.height/2-2, self.nameLabel.frame.size.width, self.frame.size.height/2);
    
    _bgImageView.frame = self.bounds;
    _bgImageView.frame = CGRectMake(KLivePresentViewWidthSpace, 0, self.frame.size.width - KLivePresentViewWidthSpace, self.frame.size.height);
    
    _bgImageView.layer.cornerRadius = self.frame.size.height / 2;
    _bgImageView.layer.masksToBounds = YES;
    
    self.skLabel.frame = CGRectMake(CGRectGetMaxX(_giftImageView.frame),self.frame.size.height-KLiveShakeLabelHight, KLiveShakeLabelWidth, KLiveShakeLabelHight);
    
}

#pragma mark - 对外接口

- (void)setModel:(XWGiftModel *)model {
    
    self.nameLabel.text = model.user.userName;
    self.giftLabel.text = [NSString stringWithFormat:@"送出【%@】",model.giftName];
    self.giftCount = model.giftCount;
    
    _headImageView.image = model.headImage;
    _giftImageView.image = model.giftImage;
}


- (void)animateWithCompleteBlock:(completeBlock)completed{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self shakeNumberLabel];
    }];
    self.completeBlock = completed;
    
    
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
