//
//  ViewController.m
//  XWSequentialAnimation
//
//  Created by 邱学伟 on 2017/5/7.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"
//#import "UIImageView+XWSequential.h"
#import "XWSequentialImageView.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *sequentialImages;

@property (weak, nonatomic) IBOutlet XWSequentialImageView *showSequentialImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)showSequentialImagesClick:(UIButton *)sender {
    
    [self.showSequentialImageView showSequentialImagesWithImageName:@"dlw_yj010" imagesCount:34 imageAnimationDuration:3];
}
@end
