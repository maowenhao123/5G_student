//
//  BaseVideoViewController.m
//  5G_student
//
//  Created by dahe on 2020/3/11.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BaseVideoViewController.h"
#import "SJVideoPlayer.h"
#import "AppDelegate.h"

@interface BaseVideoViewController ()

@property (nonatomic, strong) SJVideoPlayer *videoPlayer;

@end

@implementation BaseVideoViewController

#pragma mark - 控制器
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.videoPlayer vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.videoPlayer vc_viewWillDisappear];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.videoPlayer vc_viewDidDisappear];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.videoPlayer.view];
    self.videoPlayer.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:@"https://zyimg.dahe.cn/bce6c31b-66e6-45a0-b796-39b9a0ae5b09.m3u8"]];
}

- (BOOL)prefersHomeIndicatorAutoHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

#pragma mark - Getting
- (SJVideoPlayer *)videoPlayer
{
    if (!_videoPlayer) {
        _videoPlayer = [SJVideoPlayer player];
        _videoPlayer.view.frame = CGRectMake(0, 0, MScreenHeight, MScreenWidth);
        SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull commonSettings) {
            commonSettings.bottomIndicator_traceColor = MDefaultColor;
            commonSettings.progress_traceColor = MDefaultColor;
            commonSettings.more_traceColor = MDefaultColor;
            commonSettings.noNetworkButtonBackgroundColor = MDefaultColor;
            commonSettings.playFailedButtonBackgroundColor = MDefaultColor;
        });
        __weak typeof(self) wself = self;
        _videoPlayer.rotationObserver.rotationDidStartExeBlock = ^(id<SJRotationManager>  _Nonnull mgr) {
            __strong typeof(self) sself = wself;
            if (!mgr.isFullscreen) {
                [sself->_videoPlayer needShowStatusBar];
            }else
            {
                [sself->_videoPlayer needHiddenStatusBar];
            }
        };
    }
    return _videoPlayer;
}


@end
