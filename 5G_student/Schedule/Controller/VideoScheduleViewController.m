//
//  VideoScheduleViewController.m
//  5G_student
//
//  Created by dahe on 2020/3/9.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "VideoScheduleViewController.h"
#import "VideoScheduleInfoTableViewCell.h"
#import "VideoSchedulePeriodTableViewCell.h"
#import "SJVideoPlayer.h"
#import "AppDelegate.h"

@interface VideoScheduleViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SJVideoPlayer *videoPlayer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CourseModel *courseModel;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation VideoScheduleViewController

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
    self.title = @"视频课";
    [self setupUI];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self getCourseData];
}

- (BOOL)prefersHomeIndicatorAutoHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 请求数据
- (void)getCourseData
{
    NSDictionary *parameters = @{
        @"courseId": self.courseId
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/view" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            CourseModel *courseModel = [CourseModel mj_objectWithKeyValues:json[@"data"]];
            courseModel.periodList = [PeriodModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"periodList"]];
            self.courseModel = courseModel;
            if (courseModel.periodList.count > 0) {
                PeriodModel *periodModel = self.courseModel.periodList[0];
                [self getVideoUrlWithVideoNo:periodModel.periodVideo.videoNo];
            }
            [self.tableView reloadData];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)getVideoUrlWithVideoNo:(NSString *)videoNo
{
    self.videoPlayer.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:@"https://zyimg.dahe.cn/bce6c31b-66e6-45a0-b796-39b9a0ae5b09.m3u8"]];
    return;
    
    if (MStringIsEmpty(videoNo)) {
        return;
    }
    
    NSDictionary *parameters = @{
        @"videoNo": videoNo
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/chapter/period/audit/video" success:^(id json) {
        if (SUCCESS) {
            //            self.playerView.url = [NSURL URLWithString:json[@"data"]];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        
    }];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.videoPlayer.view;
    
    //底部
    CGFloat bottomViewH = 60;
    if (IsBangIPhone) {
        bottomViewH = 50 + MSafeBottomMargin;
    }
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MScreenHeight - bottomViewH, MScreenWidth, bottomViewH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 1)];
    bottomLine.backgroundColor = MWhiteLineColor;
    [bottomView addSubview:bottomLine];
    
    UIButton * consultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    consultButton.frame = CGRectMake(MMargin, 10, MScreenWidth - 2 * MMargin, 40);
    consultButton.backgroundColor = MDefaultColor;
    [consultButton setTitle:@"联系老师" forState:UIControlStateNormal];
    [consultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    consultButton.titleLabel.font = [UIFont systemFontOfSize:16];
    consultButton.layer.cornerRadius = consultButton.height / 2;
    consultButton.layer.masksToBounds = YES;
    [consultButton addTarget:self action:@selector(consultButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:consultButton];
    
    //返回
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(MMargin, MStatusBarH + 6, 32, 32);
    [backButton setImage:[UIImage imageNamed:@"gray_background_back_bar"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

#pragma mark - 点击事件
- (void)backButtonDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)consultButtonDidClick
{
    
}

#pragma mark - Getting
- (SJVideoPlayer *)videoPlayer
{
    if (!_videoPlayer) {
        _videoPlayer = [SJVideoPlayer player];
        _videoPlayer.view.frame = CGRectMake(0, 0, MScreenWidth, MStatusBarH + 250);
        _videoPlayer.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
        _videoPlayer.defaultEdgeControlLayer.bottomProgressIndicatorHeight = 3;
        SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull commonSettings) {
            commonSettings.bottomIndicator_traceColor = MDefaultColor;
            commonSettings.progress_traceColor = MDefaultColor;
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

- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat bottomViewH = 60;
        if (IsBangIPhone) {
            bottomViewH = 50 + MSafeBottomMargin;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - bottomViewH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 60;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.courseModel.periodList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        VideoScheduleInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VideoScheduleInfoTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"VideoScheduleInfoTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        cell.info = self.courseModel.courseName;
        return cell;
    }else
    {
        VideoSchedulePeriodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VideoSchedulePeriodTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"VideoSchedulePeriodTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        cell.checked = self.selectedIndex == indexPath.row;
        cell.periodModel = self.courseModel.periodList[indexPath.row];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 0.01)];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 9)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == self.selectedIndex) {
            return;
        }
        self.selectedIndex = indexPath.row;
        [self.tableView reloadData];
        
        PeriodModel *periodModel = self.courseModel.periodList[indexPath.row];
        [self getVideoUrlWithVideoNo:periodModel.periodVideo.videoNo];
    }
}

@end
