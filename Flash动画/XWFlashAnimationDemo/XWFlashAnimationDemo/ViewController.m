//
//  ViewController.m
//  XWFlashAnimationDemo
//
//  Created by 邱学伟 on 2017/3/23.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "XWFlashManager.h"
#import "FlashGiftModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (NSArray *)flashArr {
    return @[@"bieshu",@"laba",@"mutiFlowerDrop",@"mutiFlowerRandom",@"testFlash",@"heiniao"];
}

- (IBAction)showLocalFlashAnim:(UIButton *)sender {
    FlashGiftModel *giftModel = [[FlashGiftModel alloc] init];
    giftModel.animName = @"test1";
    [[XWFlashManager shareInstance] playFlashAnimation:giftModel endBlock:^{
        NSLog(@"测试动画播放完毕");
    }];
}

/// 随机播放flash动画
- (IBAction)playRandomFlash:(UIButton *)sender {
    NSString *flashName = [[self flashArr] objectAtIndex:arc4random_uniform(5)];
    FlashGiftModel *giftModel = [[FlashGiftModel alloc] init];
    giftModel.animName = flashName;
    if ([flashName isEqualToString:@"heiniao"]) {
        giftModel.zipUrl = @"https://github.com/hardman/OutLinkImages/raw/master/FlashAnimationToMobile/zips/heiniao.zip";
    }
    [[XWFlashManager shareInstance] playFlashAnimation:giftModel endBlock:^{
        NSLog(@"测试动画播放完毕");
    }];
}

/// 加载网络动画并播放
- (IBAction)showNetworkFlashAnim:(UIButton *)sender {

    FlashGiftModel *giftModel = [[FlashGiftModel alloc] init];
    giftModel.animName = @"heiniao";
    giftModel.version = @"1";
    giftModel.zipUrl = @"https://github.com/hardman/OutLinkImages/raw/master/FlashAnimationToMobile/zips/heiniao.zip";
    [[XWFlashManager shareInstance] playFlashAnimation:giftModel endBlock:^{
        NSLog(@"测试动画播放完毕");
    }];
}




@end
