//
//  ViewController.m
//  XWMoviePlayer
//
//  Created by 邱学伟 on 2017/5/7.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "PlayerVideoVC.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, copy) NSString *path;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)playVideo:(UIButton *)sender {
//    [self.player play];
    PlayerVideoVC *vc = [[PlayerVideoVC alloc] init];
    vc.videoName = @"testShu.mp4";
    [self presentViewController:vc animated:YES completion:nil];
}





- (AVPlayer *)player
{
    if (_player == nil) {
        // 1.获取URL(远程/本地)
        // NSURL *url = [[NSBundle mainBundle] URLForResource:@"01-知识回顾.mp4" withExtension:nil];
        NSURL *url = [NSURL URLWithString:self.path];
        
        // 2.创建AVPlayerItem
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        
        // 3.创建AVPlayer
        _player = [AVPlayer playerWithPlayerItem:item];
        
        // 4.添加AVPlayerLayer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        layer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        [self.view.layer addSublayer:layer];
    }
    return _player;
}

- (NSString *)path {
    if(!_path){
        _path = [[NSBundle mainBundle] pathForResource:@"testShu.mp4" ofType:nil];;
    }
    return _path;
}



@end
