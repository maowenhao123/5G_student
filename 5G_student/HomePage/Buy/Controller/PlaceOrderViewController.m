//
//  PlaceOrderViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/3/2.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "PlaceOrderViewController.h"
#import "PayOrderViewController.h"
#import "CourseModel.h"

@interface PlaceOrderViewController ()

@property (nonatomic, weak) UILabel * moneyLabel;
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

#pragma mark - 布局子视图
- (void)setupUI
{
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
    [self.navigationController pushViewController:payOrderVC animated:YES];
}

@end
