//
//  ViewController.m
//  XWFlashAnimationDemo
//
//  Created by 邱学伟 on 2017/3/23.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "XWFlashManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (NSArray *)flashArr {
    return @[@"bieshu",@"laba",@"mutiFlowerDrop",@"mutiFlowerRandom",@"testFlash"];
}

- (IBAction)showLocalFlashAnim:(UIButton *)sender {
    NSString *flashName = [[self flashArr] objectAtIndex:arc4random_uniform(5)];
    NSLog(@"flashName: %@",flashName);
    [[XWFlashManager shareInstance] playFlashAnimationWithName:@"tanghulu" endBlock:^{
        
    }];
}
- (IBAction)showNetworkFlashAnim:(UIButton *)sender {
    [[XWFlashManager shareInstance] playNetWorkFlashAnimationWithURL:@"https://github.com/hardman/OutLinkImages/raw/master/FlashAnimationToMobile/zips/heiniao.zip"];
}
- (IBAction)showFlashAnim:(UIButton *)sender {
    NSString *flashName = [[self flashArr] objectAtIndex:arc4random_uniform(5)];
    NSLog(@"flashName: %@",flashName);
    [[XWFlashManager shareInstance] playFlashAnimationWithName:flashName endBlock:^{
        
    }];

//    [[XWFlashManager shareInstance] playNetWorkFlashAnimationWithURL:@"https://github.com/hardman/OutLinkImages/raw/master/FlashAnimationToMobile/zips/heiniao.zip"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
