//
//  ViewController.m
//  XWLottieDemo
//
//  Created by 邱学伟 on 2017/5/9.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import <Lottie/Lottie.h>

//判断是横屏竖屏
#define iSLandscapeRight [UIApplication sharedApplication].statusBarOrientation != UIDeviceOrientationPortrait ? YES : NO

@interface ViewController ()
@property (strong, nonatomic) LOTAnimationView *lottieAnimationView;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.lottieAnimationView];
}

/**
 播放Lottie动画

 @param name 动画JSON文件名称 - 保证程序中存在否则崩溃
 */
- (void)showLottieAnimationWithName:(NSString *)name {
    self.lottieAnimationView = [LOTAnimationView animationNamed:name];
//    self.lottieAnimationView.frame =  CGRectMake(0, 44, 125, 102);
        self.lottieAnimationView.frame =  self.view.bounds;
    self.lottieAnimationView.center = CGPointMake(self.view.center.x, self.lottieAnimationView.center.y);
    [self.view addSubview:self.lottieAnimationView];
    //循环播放
    _lottieAnimationView.loopAnimation = NO;// YES;
    //从URL加载
    //    LAAnimationView *animation = [[LAAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:URL]];
    //设置动画的进度
    //animation.animationProgress = 0
    [_lottieAnimationView playWithCompletion:^(BOOL animationFinished) {
        NSLog(@"++ 动画播放完成!");
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showLottieAnimationWithName:@"love"];
}

- (IBAction)showAnim:(id)sender {
    
}

- (LOTAnimationView *)lottieAnimationView {
    if(!_lottieAnimationView){
        _lottieAnimationView = [[LOTAnimationView alloc] init];
        _lottieAnimationView.frame = [UIScreen mainScreen].bounds;
    }
    return _lottieAnimationView;
}

@end
