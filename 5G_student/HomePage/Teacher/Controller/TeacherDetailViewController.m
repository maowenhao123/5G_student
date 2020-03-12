//
//  TeacherDetailViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/23.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "TeacherDetailViewController.h"
#import "CourseDetailViewController.h"
#import "TeacherInfoTableViewCell.h"
#import "TeacherShowTableViewCell.h"
#import "CourseTableViewCell.h"
#import "TeacherHeaderFooterView.h"

@interface TeacherDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *courseArray;
@property (nonatomic, assign) NSInteger pageCurrent;
@property (nonatomic, strong) LecturerModel *lecturerModel;

@end

@implementation TeacherDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.pageCurrent = 1;
    [self getTeacherData];
    [self getCourseData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 请求数据
- (void)getTeacherData
{
    NSDictionary *parameters = @{
        @"lecturerId": self.teacherId
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/lecturer/view" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.lecturerModel = [LecturerModel mj_objectWithKeyValues:json[@"data"]];
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

- (void)getCourseData
{
    NSDictionary *parameters = @{
        @"lecturerUserNo": self.teacherId,
        @"pageCurrent": @(self.pageCurrent),
        @"pageSize": MPageSize
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/list" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            NSArray * dataArray = [CourseModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
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
    
    //返回
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(MMargin, MStatusBarH + 6, 32, 32);
    [backButton setImage:[UIImage imageNamed:@"gray_background_back_bar"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)backButtonDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getting
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 230;
        
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.courseArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TeacherInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherInfoTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"TeacherInfoTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        cell.teacherId = self.teacherId;
        cell.lecturerModel = self.lecturerModel;
        return cell;
    }else if (indexPath.section == 1)
    {
        TeacherShowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherShowTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"TeacherShowTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        cell.lecturerModel = self.lecturerModel;
        return cell;
    }else if (indexPath.section == 2)
    {
        CourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"CourseTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        cell.courseModel = self.courseArray[indexPath.row];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 0.01)];
        return headerView;
    }else
    {
        TeacherHeaderFooterView * headerView = [TeacherHeaderFooterView headerViewWithTableView:tableView];
        if (section == 1) {
            headerView.titleLabel.text = @"才艺展示";
            headerView.moreButton.hidden = NO;
            headerView.lecturerModel = self.lecturerModel;
        }else if (section == 2)
        {
            headerView.titleLabel.text = @"课程";
            headerView.moreButton.hidden = YES;
        }
        return headerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 0.01)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return 130;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2)
    {
        return 9 + 45;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        CourseDetailViewController * courseDetailVC = [[CourseDetailViewController alloc] init];
        CourseModel *courseModel = self.courseArray[indexPath.row];
        courseDetailVC.courseId = courseModel.id;
        [self.navigationController pushViewController:courseDetailVC animated:YES];
    }
}


@end
