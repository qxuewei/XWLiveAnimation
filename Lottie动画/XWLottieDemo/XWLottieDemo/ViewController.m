//
//  ViewController.m
//  XWLottieDemo
//
//  Created by 邱学伟 on 2017/5/9.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import <Lottie/Lottie.h>

@interface ViewController ()
@property (strong, nonatomic) LOTAnimationView *lottieAnimationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    self.lottieAnimationView = [LOTAnimationView animationNamed:@"data"];
    self.lottieAnimationView = [LOTAnimationView animationNamed:@"data"];
//    self.lottieAnimationView setAnimation
    self.lottieAnimationView.frame = CGRectMake(0, 44, 300, 288);
    self.lottieAnimationView.center = CGPointMake(self.view.center.x, self.lottieAnimationView.center.y);
    [self.view addSubview:self.lottieAnimationView];
    
    //循环播放
//    _lottieAnimationView.loopAnimation = YES;
    //从URL加载
    //    LAAnimationView *animation = [[LAAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:URL]];
    //设置动画的进度
    //animation.animationProgress = 0
    [_lottieAnimationView playWithCompletion:^(BOOL animationFinished) {
        NSLog(@"++ 动画播放完成!");
    }];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_lottieAnimationView playWithCompletion:^(BOOL animationFinished) {
        NSLog(@"++ 动画播放完成!");
    }];
}

- (IBAction)showAnim:(id)sender {
    
}

- (LOTAnimationView *)lottieAnimationView {
    if(!_lottieAnimationView){
        _lottieAnimationView = [[LOTAnimationView alloc] init];
    }
    return _lottieAnimationView;
}

@end
