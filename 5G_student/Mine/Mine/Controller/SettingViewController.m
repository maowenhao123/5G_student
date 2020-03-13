//
//  SettingViewController.m
//  5G_student
//
//  Created by dahe on 2020/3/12.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "SettingViewController.h"
#import "MUserDefaultTool.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    self.title = @"设置";
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    UIButton * loginoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginoutButton.frame = CGRectMake(MMargin, 200, MScreenWidth - 2 * MMargin, 40);
    loginoutButton.backgroundColor = MDefaultColor;
    [loginoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    loginoutButton.layer.cornerRadius = loginoutButton.height / 2;
    loginoutButton.layer.masksToBounds = YES;
    [loginoutButton addTarget:self action:@selector(loginoutButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginoutButton];
}

- (void)loginoutButtonDidClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //删除用户的个人数据
        [MUserDefaultTool saveObject:@"" forKey:@"token"];
        [MUserDefaultTool saveObject:@"" forKey:@"userno"];
        
        dispatch_time_t poptime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(poptime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            //退出登录，发送返回首页通知
            NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:NO];
                });
            }];
            
            NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoHomePage" object:nil];
                });
            }];
            [op2 addDependency:op1];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue waitUntilAllOperationsAreFinished];
            [queue addOperation:op1];
            [queue addOperation:op2];
        });
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
