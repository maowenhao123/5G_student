//
//  PaySuccessViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/3/2.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "PaySuccessViewController.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"支付结果";
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    CGFloat iconImageViewWH = 65;
    UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((MScreenWidth - iconImageViewWH) / 2, 50, iconImageViewWH, iconImageViewWH)];
    iconImageView.image = [UIImage imageNamed:@"login_icon"];
    [self.view addSubview:iconImageView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(iconImageView.frame) + MMargin, MScreenWidth - 2 * MMargin, 20)];
    titleLabel.text = @"支付成功";
    titleLabel.textColor = MBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    CGFloat buttonW = 118;
    CGFloat buttonH = 39;
    CGFloat buttonY = CGRectGetMaxY(titleLabel.frame) + 30;
    CGFloat paddingButton = 60;
    CGFloat padding = (MScreenWidth - 2 * buttonW - paddingButton) / 2;
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(padding + (buttonW + paddingButton) * i, buttonY, buttonW, buttonH);
        if (i == 0) {
            [button setTitle:@"查看订单" forState:UIControlStateNormal];
        }else
        {
            [button setTitle:@"返回首页" forState:UIControlStateNormal];
        }
        [button setTitleColor:MBlackTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = buttonH / 2;
        button.layer.borderColor = MWhiteLineColor.CGColor;
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)buttonDidClick:(UIButton *)button
{
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (button.tag == 0) {//查看订单
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoMine" object:nil];
            }else//返回首页
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoHomePage" object:nil];
            }
        });
    }];
    [op2 addDependency:op1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue waitUntilAllOperationsAreFinished];
    [queue addOperation:op1];
    [queue addOperation:op2];
}

@end
