//
//  PlaceOrderViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/3/2.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "PlaceOrderViewController.h"
#import "PayOrderViewController.h"
#import "BuyCourseTableViewCell.h"

@interface PlaceOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UILabel * moneyLabel;
@property (nonatomic, weak) UIButton * payButton;
@property (nonatomic, strong) CourseModel *courseModel;

@end

@implementation PlaceOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"确认订单";
    [self setupUI];
    [self getCourseData];
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
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - Setting
- (void)setCourseModel:(CourseModel *)courseModel
{
    _courseModel = courseModel;
    
    NSString * moneyStr = [NSString stringWithFormat:@"¥%@", _courseModel.courseOriginal];
    NSMutableAttributedString * moneyAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付款：%@", moneyStr]];
    [moneyAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, moneyAttStr.length)];
    [moneyAttStr addAttribute:NSForegroundColorAttributeName value:MBlackTextColor range:NSMakeRange(0, moneyAttStr.length)];
    [moneyAttStr addAttribute:NSForegroundColorAttributeName value:MDefaultColor range:[moneyAttStr.string rangeOfString:moneyStr]];
    self.moneyLabel.attributedText = moneyAttStr;
    [self.tableView reloadData];
    
     if (_courseModel.courseType == 3) {
         [self.payButton setTitle:@"立即预约" forState:UIControlStateNormal];
     }else
     {
         [self.payButton setTitle:@"立即支付" forState:UIControlStateNormal];
     }
}

#pragma mark - 布局子视图
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    
    //底部
    CGFloat bottomViewH = 55;
    if (IsBangIPhone) {
        bottomViewH = 45 + MSafeBottomMargin;
    }
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MScreenHeight - MStatusBarH - MNavBarH - bottomViewH, MScreenWidth, bottomViewH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 1)];
    bottomLine.backgroundColor = MWhiteLineColor;
    [bottomView addSubview:bottomLine];
    
    UILabel * moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, 10, MScreenWidth - MMargin - 100, 30)];
    self.moneyLabel = moneyLabel;
    [bottomView addSubview:moneyLabel];
    
    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton = payButton;
    payButton.frame = CGRectMake(MScreenWidth - 100, 10, 90, 35);
    payButton.backgroundColor = MDefaultColor;
    [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:14];
    payButton.layer.cornerRadius = payButton.height / 2;
    payButton.layer.masksToBounds = YES;
    [payButton addTarget:self action:@selector(payButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:payButton];
}

- (void)payButtonDidClick
{
    PayOrderViewController * payOrderVC = [[PayOrderViewController alloc] init];
    payOrderVC.courseId = self.courseId;
    payOrderVC.periodId = self.periodId;
    [self.navigationController pushViewController:payOrderVC animated:YES];
}

#pragma mark - Getting
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat tableViewH = MScreenHeight - MStatusBarH - MNavBarH - 45 - MSafeBottomMargin;
        if (self.navigationController.viewControllers.count > 1) {
            tableViewH = MScreenHeight - MStatusBarH - MNavBarH - 55;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, tableViewH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyCourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BuyCourseTableViewCell"];
    if (cell == nil) {
        cell = [[UINib nibWithNibName:@"BuyCourseTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    }
    cell.periodId = self.periodId;
    cell.courseModel = self.courseModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

@end
