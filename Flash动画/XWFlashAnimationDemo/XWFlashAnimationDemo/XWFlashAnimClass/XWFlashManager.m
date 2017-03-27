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
#import "MBProgressHUD+XW.h"
#import "ZipArchive.h"


@interface XWFlashManager ()<FlashViewDownloadDelegate>

@property (nonatomic, strong) FlashViewNew *flashViewOrientationVer; //竖屏视图
@property (nonatomic, strong) FlashViewNew *flashViewOrientationHor; //横屏视图
@property (nonatomic, copy) NSString * currAnim;
@property (nonatomic, unsafe_unretained) NSInteger loopTimes;
@property (nonatomic, unsafe_unretained) NSInteger currAnimIndex;

@property (nonatomic,assign) BOOL isPlayFlash;

@end

@implementation XWFlashManager
static XWFlashManager *_defaultManager;

#pragma mark - public



- (void)playFlashAnimationWithName:(NSString *)animName {
    
    if ([XWFlashManager isOrientationPortrait]) {
        [self startFlashAnimation:self.flashViewOrientationVer animName:animName];
    }else{
        [self startFlashAnimation:self.flashViewOrientationHor animName:animName];
    }
}


-(void)playNetWorkFlashAnimationWithURL:(NSString *)giftUrl  {
    
    NSString *animFlaName = [[giftUrl lastPathComponent] stringByDeletingPathExtension];
    if ([FlashViewNew isAnimExist:animFlaName]) {
        NSLog(@"动画文件存在");
        [self playFlashAnimationWithName:animFlaName];
        return;
    }
    
    FlashViewDownloader *downloader = [[FlashViewDownloader alloc] init];
    downloader.delegate = self;
    __weak XWFlashManager *weakSelf = self;
    [downloader downloadAnimFileWithUrl:giftUrl saveFileName:@"heiniao.zip" animFlaName:animFlaName version:@"1" downType:ZIP percentCb:^(float per) {
        NSLog(@"下载进度:%f",per);
        [MBProgressHUD showHUD];
        
    } completeCb:^(BOOL succ) {
        if (succ) {
            [weakSelf playFlashAnimationWithName:animFlaName];
            NSLog(@"动画下载成功并播放");
        }else{
            NSLog(@"下载动画后播放失败");
        }
        [MBProgressHUD hide];
    }];

}



#pragma mark FlashViewDownloadDelegate 自定义下载文件的函数，可以自己选择下载和解压文件的方法
-(void)downloadFlashFileWithUrl:(NSString *)url outFile:(NSString *)outFile percentCb:(DownloadPercentCallback)percentCb completeCb:(DownloadCompleteCallback)completeCb{
    NSLog(@"开始下载:%@", url);
    [MBProgressHUD showHUD];
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
        //关闭loadingview
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hide];
        });
    }];
    [downloadTask resume];
}

-(BOOL)unzipDownloadedFlashFile:(NSString *)zipFile toDir:(NSString *)dir{
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile:zipFile]) {
        BOOL ret = [za UnzipFileTo:dir overWrite:YES];
        if (!ret) {
            [za UnzipCloseFile];
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)startFlashAnimation:(FlashViewNew *)flashViewNew animName:(NSString *)animName{

    
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
    
    
    __weak typeof(self) weakCtl = self;
    __weak FlashViewNew *weakFlashView = flashViewNew;
    flashViewNew.onEventBlock = ^(FlashViewEvent evt, id data){
        if (evt == FlashViewEventStop) {
            if (weakCtl.currAnimIndex >= anims.count - 1) {
                [weakFlashView removeFromSuperview];
                weakCtl.currAnimIndex = 0;
                weakCtl.currAnim = nil;
            }else{
                weakCtl.currAnimIndex++;
                
                [weakCtl startFlashAnimation:weakFlashView animName:animName];
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
-(FlashViewNew *)flashViewOrientationVer{
    if (!_flashViewOrientationVer) {
        _flashViewOrientationVer = [[FlashViewNew alloc] init];
        _flashViewOrientationVer.designScreenOrientation = FlashViewScreenOrientationVer;
        _flashViewOrientationVer.screenOrientation = FlashViewScreenOrientationVer;
        _flashViewOrientationVer.animPosMask = FlashViewAnimPosMaskVerCenter | FlashViewAnimPosMaskHorCenter;
    }
    return _flashViewOrientationVer;
}

/// 横屏动画视图
-(FlashViewNew *)flashViewOrientationHor{
    if (!_flashViewOrientationHor) {
        _flashViewOrientationHor = [[FlashViewNew alloc] init];
        _flashViewOrientationHor.designScreenOrientation = FlashViewScreenOrientationHor;
        _flashViewOrientationHor.screenOrientation = FlashViewScreenOrientationHor;
        _flashViewOrientationHor.animPosMask = FlashViewAnimPosMaskVerCenter | FlashViewAnimPosMaskHorCenter;
    }
    return _flashViewOrientationHor;
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
