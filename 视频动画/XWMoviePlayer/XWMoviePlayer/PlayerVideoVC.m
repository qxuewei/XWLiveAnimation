//
//  PlayerVideoVC.m
//  VideoGather
//
//  Created by 邱学伟 on 16/6/23.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "PlayerVideoVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerVideoVC (){
    AVPlayerItem *playerItem;
}
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器

@end

@implementation PlayerVideoVC
//- (BOOL)prefersStatusBarHidden {
//    return NO;
//}
- (void)viewDidLoad {
    [super viewDidLoad];

    //播放
    [self.moviePlayer play];
    //添加通知
    [self addNotification];
}

-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)cencelBtnClick{
    [self.moviePlayer stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 私有方法
/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getFileUrl{
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"testShu.mp4" ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:fullPath];
    return url;
}


/**
 *  创建媒体播放控制器
 *
 *  @return 媒体播放控制器
 */
-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        NSURL *url=[self getFileUrl];
        _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
        _moviePlayer.view.frame=self.view.bounds;
        _moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_moviePlayer setControlStyle:MPMovieControlStyleNone];
        [self.view addSubview:_moviePlayer.view];
    }
    return _moviePlayer;
}

/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
