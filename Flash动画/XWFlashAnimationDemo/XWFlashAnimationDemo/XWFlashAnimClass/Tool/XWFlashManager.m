//
//  XWFlashManager.m
//  FlashAnimtionDemo
//
//  Created by 邱学伟 on 2017/3/21.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWFlashManager.h"

#import "FlashViewNew.h"
#import "FlashViewDownloader.h"
#import "ZipArchive.h"
#import "GiftModel.h"
#import "FlashGiftModel.h"

@interface XWFlashManager ()<FlashViewDownloadDelegate>

@property (nonatomic, strong) GiftModel *giftModel;
@property (nonatomic, strong) FlashViewNew *flashView;
@property (nonatomic, copy) NSString * currAnim;
@property (nonatomic, unsafe_unretained) NSInteger loopTimes;
@property (nonatomic, unsafe_unretained) NSInteger currAnimIndex;

@property (nonatomic,assign) BOOL isPlayFlash;

@end

@implementation XWFlashManager
static XWFlashManager *_defaultManager;

#pragma mark - public
/// 开机获取flash动画 Url和version以及animName 下载压缩包并解压
- (void)downloadAndUnZipWith:(FlashGiftModel *)flashGiftModel {
    [self downloadAndUnZipWith:flashGiftModel completeCb:nil];
}

/// 获取当前flashView
- (FlashViewNew *)getFlashView {
    return self.flashView;
}

/// 播放flash动画
- (void)playFlashAnimation:(FlashGiftModel *)flashGiftModel endBlock:(FlashAnimCallback)animEnd {
    //判断当前是否存在此 flash 动画文件
    if (![FlashViewNew isAnimExist:flashGiftModel.animName]) {
        // 不存在 下载并解压后播放
        [self downloadAndUnZipWith:flashGiftModel completeCb:^(BOOL succ) {
            if (succ) {
                [self playFlashAnimationWithName:flashGiftModel.animName endBlock:animEnd];
            }
        }];
    }else {
        // 直接播放
        [self playFlashAnimationWithName:flashGiftModel.animName endBlock:animEnd];
    }
}


#pragma mark - private
- (void)downloadAndUnZipWith:(FlashGiftModel *)flashGiftModel completeCb:(DownloadCompleteCallback) completeCb{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FlashViewDownloader *downloader = [[FlashViewDownloader alloc] init];
        downloader.delegate = self;
        [downloader downloadAnimFileWithUrl:flashGiftModel.zipUrl saveFileName:[flashGiftModel.animName stringByAppendingString:@".zip"] animFlaName:flashGiftModel.animName version:flashGiftModel.version downType:ZIP percentCb:^(float per) {
            NSLog(@"下载进度:%f",per);
        } completeCb:^(BOOL succ) {
            if (completeCb) {
                completeCb(succ);
            }
            if (succ) {
                NSLog(@"动画下载成功");
            }else{
                NSLog(@"下载动画后播放失败");
            }
        }];
    });
}

// 根据flash文件名播放flash动画
- (void)playFlashAnimationWithName:(NSString *)animName endBlock:(FlashAnimCallback)animEnd{
    if ([XWFlashManager isOrientationPortrait]) {
        // 竖屏
        self.flashView.screenOrientation = FlashViewScreenOrientationVer;
    }else{
        // 横屏
        self.flashView.screenOrientation = FlashViewScreenOrientationHor;
    }
    [self startFlashAnimation:self.flashView animName:animName endBlock:animEnd];
}

#pragma mark FlashViewDownloadDelegate 自定义下载文件的函数，可以自己选择下载和解压文件的方法
/// 下载flash压缩包网络方法
-(void)downloadFlashFileWithUrl:(NSString *)url outFile:(NSString *)outFile percentCb:(DownloadPercentCallback)percentCb completeCb:(DownloadCompleteCallback)completeCb{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"下载失败：%@, url=%@", error, url);
            completeCb(NO);
        }else{
            NSError *moveItemError = nil;
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:outFile] error:&moveItemError];
            if (moveItemError) {
                NSLog(@"文件下载成功后无法从%@移动到%@", location, outFile);
                completeCb(NO);
            }else{
                NSLog(@"下载成功");
                completeCb(YES);
            }
        }
    }];
    [downloadTask resume];
}

/// 解压
-(BOOL)unzipDownloadedFlashFile:(NSString *)zipFile toDir:(NSString *)dir{
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile:zipFile]) {
        BOOL ret = [za UnzipFileTo:dir overWrite:YES];
        if (!ret) {
            [za UnzipCloseFile];
            NSLog(@"您的压缩包有问题!!");
            return NO;
        }
        return YES;
    }
    return NO;
}

/// 播放动画
- (void)startFlashAnimation:(FlashViewNew *)flashViewNew animName:(NSString *)animName endBlock:(FlashAnimCallback)animEnd{
    
    flashViewNew.userInteractionEnabled = NO;
    if (!self.currAnim) {
        if(![flashViewNew reload:animName]){
            NSLog(@"reload error for name %@", animName);
            return;
        }
        if (!flashViewNew.superview) {
            [[XWFlashManager getCurrentUIVC].view addSubview:flashViewNew];
        }
        self.currAnim = animName;
    }
    NSArray *anims = flashViewNew.animNames;
    NSLog(@"anims: - %@",anims);
    if (anims.count == 0) {
        return;
    }
    [flashViewNew play:anims[self.currAnimIndex] loopTimes:self.loopTimes];
    __weak typeof(self) weakSelf = self;
    __weak FlashViewNew *weakFlashView = flashViewNew;
    flashViewNew.onEventBlock = ^(FlashViewEvent evt, id data){
        if (evt == FlashViewEventStop) {
            if (weakSelf.currAnimIndex >= anims.count - 1) {
                [weakFlashView removeFromSuperview];
                weakSelf.currAnimIndex = 0;
                weakSelf.currAnim = nil;
                if (animEnd) {
                    animEnd();
                }
            }else{
                weakSelf.currAnimIndex++;   
                [weakSelf startFlashAnimation:weakFlashView animName:animName endBlock:animEnd];
            }
        }
    };
}

#pragma mark - private
/// 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentUIVC {
    UIViewController  *superVC = [[self class]  getCurrentWindowViewController ];
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }
    return superVC;
}

/// 获取当前窗口跟控制器
+ (UIViewController *)getCurrentWindowViewController {
    UIViewController *currentWindowVC = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tempWindow in windows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        currentWindowVC = nextResponder;
    }else{
        currentWindowVC = window.rootViewController;
    }
    return currentWindowVC;
}

/// 是否竖屏
+ (BOOL)isOrientationPortrait {
    return [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait ? YES : NO;
}

#pragma mark - getter
/// 竖屏动画视图
-(FlashViewNew *)flashView{
    if (!_flashView) {
        _flashView = [[FlashViewNew alloc] init];
        _flashView.designScreenOrientation = FlashViewScreenOrientationVer;
        _flashView.screenOrientation = FlashViewScreenOrientationVer;
        _flashView.animPosMask = FlashViewAnimPosMaskVerCenter | FlashViewAnimPosMaskHorCenter;
    }
    return _flashView;
}

#pragma mark - 单例对象
+ (instancetype)shareInstance {
    
    if (!_defaultManager) {
        _defaultManager = [[self alloc] init];
        _defaultManager.loopTimes = FlashViewLoopTimeOnce;
    }
    return _defaultManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (!_defaultManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _defaultManager = [super allocWithZone:zone];
        });
    }
    return _defaultManager;
}

- (id)copyWithZone:(NSZone *)zone{
    
    return _defaultManager;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    
    return _defaultManager;
}


@end
