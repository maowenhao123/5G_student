//
//  HomeViewController.m
//  5G_student
//
//  Created by dahe on 2020/1/8.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "CourseDetailViewController.h"
#import "LiveViewController.h"
#import "MessageViewController.h"
#import "CourseTableViewCell.h"
#import "HomeHeaderView.h"
#import "HomeHeaderFooterView.h"

@interface HomeViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeHeaderView *homeHeaderView;
@property (strong, nonatomic) NSMutableArray *courseArray;
@property (nonatomic, assign) NSInteger pageCurrent;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    waitingView
    self.pageCurrent = 1;
    [self getCourseData];
}

#pragma mark - 请求数据
- (void)getCourseData
{
    NSDictionary *parameters = @{
        @"pageCurrent": @(self.pageCurrent),
        @"pageSize": MPageSize
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/latest" success:^(id json) {
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
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.messageButton];
    [self.view addSubview:self.tableView];
}

- (void)messageButtonDidClick
{
    [self.navigationController pushViewController:[LiveViewController new] animated:YES];
}

#pragma mark - Getting
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(MMargin, MStatusBarH + (MNavBarH - 30) / 2, MScreenWidth - MMargin - 50, 30)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜老师/课程";
        _searchBar.tintColor = MDefaultColor;
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.delegate = self;
        
        UITextField * searchTextField = nil;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13.0) {
            searchTextField = (UITextField *)[self findViewWithClassName:@"UITextField" inView:_searchBar];
        }else
        {
            searchTextField = [_searchBar valueForKey:@"_searchField"];
        }
       if (!MObjectIsEmpty(searchTextField)) {
            searchTextField.backgroundColor = UIColorFromRGB(0xF0F1F3);
            searchTextField.font = [UIFont systemFontOfSize:15];
            searchTextField.layer.cornerRadius = 1;
            searchTextField.layer.masksToBounds = YES;
        }
    }
    return _searchBar;
}

- (UIButton *)messageButton
{
    if (!_messageButton) {
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageButton.frame = CGRectMake(MScreenWidth - 10 - 40, MStatusBarH + (MNavBarH - 40) / 2, 40, 40);
        [_messageButton setImage:[UIImage imageNamed:@"tabber_groupon_selected"] forState:UIControlStateNormal];
        [_messageButton addTarget:self action:@selector(messageButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MStatusBarH + MNavBarH, MScreenWidth, MScreenHeight - MStatusBarH - MNavBarH - MTabBarH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 100;
        _tableView.tableHeaderView = self.homeHeaderView;
        
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

- (HomeHeaderView *)homeHeaderView
{
    if (_homeHeaderView == nil) {
        _homeHeaderView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 260)];
    }
    return _homeHeaderView;
}

- (NSMutableArray *)courseArray
{
    if (!_courseArray) {
        _courseArray = [NSMutableArray array];
    }
    return _courseArray;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
    
    return NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTableViewCell"];
    if (cell == nil) {
        cell = [[UINib nibWithNibName:@"CourseTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    }
    cell.courseModel = self.courseArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HomeHeaderFooterView * headerView = [HomeHeaderFooterView headerViewWithTableView:tableView];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 0.01)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9 + 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CourseDetailViewController * courseDetailVC = [[CourseDetailViewController alloc] init];
    CourseModel *courseModel = self.courseArray[indexPath.row];
    courseDetailVC.courseId = courseModel.id;
    [self.navigationController pushViewController:courseDetailVC animated:YES];
}

#pragma mark - 通过类名找view的subview
- (UIView *)findViewWithClassName:(NSString *)className inView:(UIView *)view
{
    Class specificView = NSClassFromString(className);
    if ([view isKindOfClass:specificView]) {
        return view;
    }
    
    if (view.subviews.count > 0) {
        for (UIView *subView in view.subviews) {
            UIView *targetView = [self findViewWithClassName:className inView:subView];
            if (targetView != nil) {
                return targetView;
            }
        }
    }
    return nil;
}

@end
