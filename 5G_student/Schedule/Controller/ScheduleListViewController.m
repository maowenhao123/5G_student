//
//  ScheduleListViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "ScheduleListViewController.h"
#import "VideoScheduleViewController.h"
#import "CourseDetailViewController.h"
#import "CourseTableViewCell.h"
#import "ScheduleModel.h"
#import "UITableView+NoData.h"

@interface ScheduleListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *courseArray;
@property (nonatomic, assign) NSInteger pageCurrent;

@end

@implementation ScheduleListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    waitingView
    self.pageCurrent = 1;
    [self getCourseData];
}

#pragma mark - 请求数据
- (void)getCourseData
{
    NSInteger courseType = 1;
    if (self.courseType == VideoCourse) {
        courseType = 1;
    }else if (self.courseType == PublicCourse)
    {
        courseType = 2;
    }else if (self.courseType == OnetooneCourse)
    {
        courseType = 3;
    }
    NSDictionary *parameters = @{
        @"courseType": @(courseType),
        @"pageCurrent": @(self.pageCurrent),
        @"pageSize": MPageSize
    };
    NSMutableDictionary *parameters_mu = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (self.status != -1) {
        [parameters_mu setValue:@(self.status) forKey:@"status"];
    }
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/order/info/list" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
           NSArray * dataArray = [ScheduleModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            if ([self.tableView.mj_header isRefreshing]) {
                [self.courseArray removeAllObjects];
            }
            [self.courseArray addObjectsFromArray:dataArray];
            [self.tableView.mj_header endRefreshing];
            if (dataArray.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [self.tableView.mj_footer endRefreshing];
            }
           [self.tableView reloadData];
        }else
        {
            ShowErrorView
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    [self.view addSubview:self.tableView];
}

#pragma mark - Getting
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat tableViewH = MScreenHeight - MStatusBarH - MNavBarH - 44 - MTabBarH;
        if (self.courseType == VideoCourse) {
            tableViewH = MScreenHeight - MStatusBarH - MNavBarH - MTabBarH;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, tableViewH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.estimatedRowHeight = 100;
        _tableView.tableFooterView = [UIView new];
        
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            wself.pageCurrent = 1;
            [wself getCourseData];
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            wself.pageCurrent ++;
            [wself getCourseData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)courseArray
{
    if (!_courseArray) {
        _courseArray = [NSMutableArray array];
    }
    return _courseArray;
}

#pragma mark - Setting
- (void)setCourseType:(CourseType)courseType
{
    _courseType = courseType;

    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView showNoDataWithRowCount:self.courseArray.count];
    return self.courseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTableViewCell"];
    if (cell == nil) {
        cell = [[UINib nibWithNibName:@"CourseTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    }
    ScheduleModel * scheduleModel = self.courseArray[indexPath.row];
    scheduleModel.course.courseType = scheduleModel.courseType;
    scheduleModel.course.lecturer = scheduleModel.lecturer;
    cell.courseModel = scheduleModel.course;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ScheduleModel * scheduleModel = self.courseArray[indexPath.row];
    if (scheduleModel.courseType == 1) {
        VideoScheduleViewController * videoScheduleVC = [[VideoScheduleViewController alloc] init];
        videoScheduleVC.courseId = scheduleModel.courseId;
        [self.navigationController pushViewController:videoScheduleVC animated:YES];
    }else
    {
        CourseDetailViewController * courseDetailVC = [[CourseDetailViewController alloc] init];
        courseDetailVC.courseId = scheduleModel.courseId;
        [self.navigationController pushViewController:courseDetailVC animated:YES];
    }
}

@end
