//
//  BalanceDetailViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/19.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BalanceDetailViewController.h"
#import "RechargeViewController.h"
#import "WithdrawViewController.h"
#import "BalanceDetailTableViewCell.h"
#import "UserModel.h"
#import "UITableView+NoData.h"

@interface BalanceDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel * balanceLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageCurrent;
@property (strong, nonatomic) NSMutableArray *balanceArray;

@end

@implementation BalanceDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"余额明细";
    [self setupUI];
    waitingView
    [self getUserData];
    self.pageCurrent = 1;
    [self getBalanceDetailData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserData) name:@"RechargeSuccess" object:nil];
}

#pragma mark - 请求数据
- (void)getUserData
{
    NSDictionary *parameters = @{
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/user/ext/view" success:^(id json) {
        if (SUCCESS) {
            UserModel *userModel = [UserModel mj_objectWithKeyValues:json[@"data"]];
            self.balanceLabel.text = [NSString stringWithFormat:@"余额%ld元", userModel.account.balance];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
    }];
}

- (void)getBalanceDetailData
{
    NSDictionary *parameters = @{
        @"type": @(0),
        @"pageCurrent": @(self.pageCurrent),
        @"pageSize": MPageSize
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/lecturer/profit/log/list" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
           NSArray * dataArray = [BalanceDetailModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            if ([self.tableView.mj_header isRefreshing]) {
                [self.balanceArray removeAllObjects];
            }
            [self.balanceArray addObjectsFromArray:dataArray];
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
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
}

#pragma mark - Getting
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 60)];
        
        [_headerView addSubview:self.balanceLabel];
        
        CGFloat buttonW = 50;
        for (int i = 0; i < 2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.frame = CGRectMake(MScreenWidth - MMargin - buttonW * (i + 1), 0, buttonW, _headerView.height);
            if (i == 0) {
                [button setTitle:@"提现" forState:UIControlStateNormal];
                [button setTitleColor:MColor(12, 205, 5, 1) forState:UIControlStateNormal];
            }else
            {
                [button setTitle:@"充值" forState:UIControlStateNormal];
                [button setTitleColor:MDefaultColor forState:UIControlStateNormal];
            }
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:button];
        }
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.height - 1, MScreenWidth, 1)];
        line.backgroundColor = MWhiteLineColor;
        [_headerView addSubview:line];
    }
    return _headerView;
}

- (UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, 0, MScreenWidth - MMargin - 120, self.headerView.height)];
        _balanceLabel.font = [UIFont boldSystemFontOfSize:18];
        _balanceLabel.textColor = MBlackTextColor;
    }
    return _balanceLabel;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), MScreenWidth, MScreenHeight - MStatusBarH - MNavBarH - CGRectGetMaxY(self.headerView.frame))];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            wself.pageCurrent = 1;
            [wself getBalanceDetailData];
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            wself.pageCurrent ++;
            [wself getBalanceDetailData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)balanceArray
{
    if (!_balanceArray) {
        _balanceArray = [NSMutableArray array];
    }
    return _balanceArray;
}

- (void)buttonDidClick:(UIButton *)button
{
    if (button.tag == 0) {
        [self.navigationController pushViewController:[WithdrawViewController new] animated:YES];
    }else
    {
        [self.navigationController pushViewController:[RechargeViewController new] animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView showNoDataWithRowCount:self.balanceArray.count];
    return self.balanceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BalanceDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BalanceDetailTableViewCell"];
    if (cell == nil) {
        cell = [[UINib nibWithNibName:@"BalanceDetailTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    }
    cell.balanceDetailModel = self.balanceArray[indexPath.row];
    return cell;
}

@end
