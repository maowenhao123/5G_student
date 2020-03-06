//
//  LiveViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/3/3.
//  Copyright © 2020 jiuge. All rights reserved.
//
#import "TXLiteAVSDK_Professional/TXLiveBase.h"
#import "TXLiteAVSDK_Professional/TRTCCloud.h"
#import "TXLiteAVSDK_Professional/TRTCCloudDelegate.h"
#import "LiveViewController.h"
#import "LiveModel.h"

@interface LiveViewController ()<TRTCCloudDelegate>
{
    TRTCCloud       *trtcCloud;
}

@property (nonatomic, strong) LiveModel *liveModel;

@end

@implementation LiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"直播";
    trtcCloud = [TRTCCloud sharedInstance];
    [trtcCloud setDelegate:self];
    [self setupUI];
    [self getLiveData];
}

#pragma mark - 请求数据
- (void)getLiveData
{
    NSDictionary *parameters = @{
        @"liveId": @"1231855721234034689"
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/period/live/sign" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.liveModel = [LiveModel mj_objectWithKeyValues:json[@"data"]];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    [self startLocalPreview:YES localView:self.view];
}

#pragma mark - Setting
- (void)setLiveModel:(LiveModel *)liveModel
{
    _liveModel = liveModel;
    
    TRTCParams *params = [[TRTCParams alloc] init];
    params.sdkAppId    = _liveModel.sdkAppId;
    params.userId      = _liveModel.userId;
    params.userSig     = _liveModel.sign;
    params.roomId      = _liveModel.roomId;
    params.role        = TRTCRoleAudience;
    [trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE];
}

- (void)startLocalPreview:(BOOL)frontCamera localView:(UIView*)localView {
    [trtcCloud setLocalViewFillMode:TRTCVideoFillMode_Fit];
    [trtcCloud startLocalPreview:frontCamera view:localView];
}

- (void)onError:(int)errCode errMsg:(NSString *)errMsg extInfo:(nullable NSDictionary *)extInfo {
    if (errCode == ERR_ROOM_ENTER_FAIL) {
        MLog(@"%@", errMsg);
        return;
    }
}

- (void)dealloc {
    if (trtcCloud != nil) {
        [trtcCloud exitRoom];
    }
    [TRTCCloud destroySharedIntance];
}

@end
