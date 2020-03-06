//
//  MyAttentionViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/23.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "TeacherDetailViewController.h"
#import "TeacherTableViewCell.h"

@interface MyAttentionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *teacherArray;
@property (nonatomic, assign) NSInteger pageCurrent;

@end

@implementation MyAttentionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的关注";
    [self setupUI];
    waitingView
    self.pageCurrent = 1;
    [self getTeacherData];
}

#pragma mark - 请求数据
- (void)getTeacherData
{
    NSDictionary *parameters = @{
        @"pageCurrent": @(self.pageCurrent),
        @"pageSize": MPageSize
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/user/focus/list" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            NSArray * dataArray = [TeacherModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            if ([self.tableView.mj_header isRefreshing]) {
                [self.teacherArray removeAllObjects];
            }
            [self.teacherArray addObjectsFromArray:dataArray];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - MStatusBarH - MNavBarH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
        
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            wself.pageCurrent = 1;
            [wself getTeacherData];
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            wself.pageCurrent ++;
            [wself getTeacherData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)teacherArray
{
    if (!_teacherArray) {
        _teacherArray = [NSMutableArray array];
    }
    return _teacherArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.teacherArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeacherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherTableViewCell"];
    if (cell == nil) {
        cell = [[UINib nibWithNibName:@"TeacherTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    }
    cell.teacherModel = self.teacherArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TeacherDetailViewController * teacherDetailVC = [[TeacherDetailViewController alloc] init];
    TeacherModel *teacherModel = self.teacherArray[indexPath.row];
    teacherDetailVC.teacherId = teacherModel.lecturer.id;
    [self.navigationController pushViewController:teacherDetailVC animated:YES];
}

@end
