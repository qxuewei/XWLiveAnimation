//
//  ViewController.m
//  XWSequentialAnimation
//
//  Created by 邱学伟 on 2017/5/7.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "XWSequentialImageView.h"
#import "XWSequentialImageModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet XWSequentialImageView *showSequentialImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)showSequentialImagesClick:(UIButton *)sender {
    XWSequentialImageModel *sequentialImageMode = [XWSequentialImageModel creatSequentialImageModelWithSequentialImageName:@"giftBig_animation_shyl_ios_s_" sequentialImagesCount:[NSNumber numberWithInt:81] sequentialImageAnimationDuration:[NSNumber numberWithInt:10]];
    [self.showSequentialImageView showSequentialImagesWithSequentialImageMode:sequentialImageMode WithCompletion:^(BOOL animationFinished) {
        NSLog(@"++ 所有动画结束!!! %ld",animationFinished);
    }];
}
@end
