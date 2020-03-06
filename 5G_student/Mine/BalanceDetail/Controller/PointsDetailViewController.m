//
//  PointsDetailViewController.m
//  5G_student
//
//  Created by dahe on 2020/3/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "PointsDetailViewController.h"
#import "BalanceDetailTableViewCell.h"

@interface PointsDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel * pointsLabel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PointsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"积分明细";
    [self setupUI];
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
        
        [_headerView addSubview:self.pointsLabel];
        
        CGFloat redemptionButtonW = 75;
        CGFloat redemptionButtonH = 32;
        UIButton * redemptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        redemptionButton.frame = CGRectMake(MScreenWidth - MMargin - redemptionButtonW, (_headerView.height - redemptionButtonH) / 2, redemptionButtonW, redemptionButtonH);
        redemptionButton.backgroundColor = MDefaultColor;
        [redemptionButton setTitle:@"换购" forState:UIControlStateNormal];
        [redemptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        redemptionButton.titleLabel.font = [UIFont systemFontOfSize:16];
        redemptionButton.layer.cornerRadius = redemptionButton.height / 2;
        redemptionButton.layer.masksToBounds = YES;
        [redemptionButton addTarget:self action:@selector(redemptionButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:redemptionButton];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.height - 1, MScreenWidth, 1)];
        line.backgroundColor = MWhiteLineColor;
        [_headerView addSubview:line];
    }
    return _headerView;
}

- (UILabel *)pointsLabel
{
    if (!_pointsLabel) {
        _pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, 0, MScreenWidth - MMargin - 120, self.headerView.height)];
        _pointsLabel.text = @"积分2000";
        _pointsLabel.font = [UIFont boldSystemFontOfSize:18];
        _pointsLabel.textColor = MBlackTextColor;
    }
    return _pointsLabel;
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
    }
    return _tableView;
}

- (void)redemptionButtonDidClick
{
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BalanceDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BalanceDetailTableViewCell"];
    if (cell == nil) {
        cell = [[UINib nibWithNibName:@"BalanceDetailTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    }
    return cell;
}


@end
