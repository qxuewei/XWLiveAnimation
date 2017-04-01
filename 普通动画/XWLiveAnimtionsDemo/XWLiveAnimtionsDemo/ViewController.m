//
//  ViewController.m
//  XWLiveAnimtionsDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "XWLiveGiftAnimationHeader.h"

@interface ViewController () {
    
    XWAnimOperationManager *manager;
    
    
    XWGiftModel *_giftModel;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView.image = [UIImage imageNamed:@"zhiboBG"];
    manager = [XWAnimOperationManager shareInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (manager != nil) {
        [manager resetDealloc];
        manager = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (manager != nil) {
        [manager resetDealloc];
        manager = nil;
    }
}


- (IBAction)commontGift:(UIButton *)sender {
    NSArray *giftImages = @[@"ic_bear_small_14th",@"flower",@"ic_soap_small_14th"];
    // 礼物模型
    long  x = 1;// arc4random() % 9+1;
    XWGiftModel *giftModel = [[XWGiftModel alloc] init];
    giftModel.giftId = 1;
    giftModel.headImage = [UIImage imageNamed:@"luffy"];
    giftModel.giftImage = [UIImage imageNamed:giftImages[arc4random_uniform(3)]];
    giftModel.giftPic  = @"https:// xxx";
    giftModel.giftName = @"一束鲜花";
    giftModel.giftCount = 1;
    _giftModel = giftModel;
    
    XWUserInfo *user = [[XWUserInfo alloc] init];
    user.userName = [NSString stringWithFormat:@"用户 %ld",x];
    user.userId   = x;
    user.headPic  = @"https:// xxx";
    giftModel.user = user;
    
    if (manager) {
        manager.parentView = self.view;
        // model 传入礼物模型
        [manager animWithGiftModel:giftModel finishedBlock:^(BOOL result) {
            NSLog(@"普通动画结束!");
        }];
    }
}

- (IBAction)commontGiftX2:(UIButton *)sender {
    
    _giftModel.giftCount++;
    if (manager) {
        manager.parentView = self.view;
        // model 传入礼物模型
        [manager animWithGiftModel:_giftModel finishedBlock:^(BOOL result) {
            NSLog(@"普通动画结束++!");
        }];
    }
}
- (IBAction)coffeeGift:(UIButton *)sender {
    
    long  x = arc4random() % 9+10;
    XWGiftModel *giftModel = [[XWGiftModel alloc] init];
    giftModel.giftId = 2;
    giftModel.headImage = [UIImage imageNamed:@"luffy"];
    giftModel.giftType = GIFT_TYPE_COOFFEE;
    giftModel.giftPic  = @"https:// xxx";
    giftModel.giftImage = [UIImage imageNamed:@"ic_soap_small_14th"];
    giftModel.giftName = @"咖啡";
    giftModel.giftCount = 1;
    _giftModel = giftModel;
    
    XWUserInfo *user = [[XWUserInfo alloc] init];
    user.userName = [NSString stringWithFormat:@"用户 %ld",x];
    user.userId   = x;
    user.headPic  = @"https:// xxx";
    giftModel.user = user;
    
    if (manager) {
        manager.parentView = self.view;
        // model 传入礼物模型
        [manager animWithGiftModel:giftModel finishedBlock:^(BOOL result) {
            NSLog(@"咖啡动画结束");
        }];
    }

}

- (IBAction)coffeeGiftX2:(UIButton *)sender {
    _giftModel.giftCount ++;
    if (manager) {
        manager.parentView = self.view;
        
        [manager animWithGiftModel:_giftModel finishedBlock:^(BOOL result) {
            NSLog(@"咖啡动画结束++");
        }];
    }
}

@end
