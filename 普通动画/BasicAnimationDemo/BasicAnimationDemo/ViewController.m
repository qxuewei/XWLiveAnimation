//
//  ViewController.m
//  BasicAnimationDemo
//
//  Created by 邱学伟 on 2017/3/28.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CAAnimationDelegate>
@property (nonatomic, strong) UIImageView *myView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self move];
//    [self rotate];
//    [self scale];
    [self move_rotate];
}

#pragma mark - 移动
- (void)move {
    
    /* 移动 */
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    animation.delegate = self;
    
    // 动画选项的设定
    animation.duration = 2.5; // 持续时间
    animation.repeatCount = 1; // 重复次数
    
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.myView.layer.position]; // 起始帧
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(320, 480)]; // 终了帧
    
    // 添加动画
    [self.myView.layer addAnimation:animation forKey:@"move-layer"];
}

#pragma mark - 旋转
- (void)rotate {
    
    /* 旋转 */
    // 对Y轴进行旋转（指定Z轴的话，就和UIView的动画一样绕中心旋转）
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 设定动画选项
    animation.duration = 2.5; // 持续时间
    animation.repeatCount = 1; // 重复次数
    
    // 设定旋转角度
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:22 * M_PI]; // 终止角度
    
    // 添加动画
    [self.myView.layer addAnimation:animation forKey:@"rotate-layer"];

}

#pragma mark - 缩放
- (void)scale {
    
    /* 放大缩小 */
    
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 2.5; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:2.0]; // 结束时的倍率
    
    // 添加动画
    [self.myView.layer addAnimation:animation forKey:@"scale-layer"];
}

#pragma mark - 组合动画
- (void)move_rotate {
    
    /* 动画1（在X轴方向移动） */
    CABasicAnimation *animation1 =
    [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    // 终点设定
    animation1.toValue = [NSNumber numberWithFloat:80];; // 終点
    
    
    /* 动画2（绕Z轴中心旋转） */
    CABasicAnimation *animation2 =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    
    // 设定旋转角度
    animation2.fromValue = [NSNumber numberWithFloat:0.0]; // 开始时的角度
    animation2.toValue = [NSNumber numberWithFloat:44 * M_PI]; // 结束时的角度
    
    
    /* 动画组 */
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    // 动画选项设定
    group.duration = 3.0;
    group.repeatCount = 1;
    group.autoreverses = YES;
    
    // 添加动画
    group.animations = [NSArray arrayWithObjects:animation1, animation2, nil];
    [self.myView.layer addAnimation:group forKey:@"move-rotate-layer"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    
    NSLog(@"移动动画开始");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    NSLog(@"移动动画结束");
}

#pragma mark - setter
- (UIImageView *)myView {
    if(!_myView){
        _myView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
        _myView.frame = CGRectMake(16, 64, 32, 80);
        CGPoint center = self.view.center;
        _myView.center = CGPointMake(center.x, _myView.center.y);
    }
    return _myView;
}

@end
