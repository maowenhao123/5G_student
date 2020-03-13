//
//  RechargeTypeViewController.m
//  5G_student
//
//  Created by dahe on 2020/3/10.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "RechargeTypeViewController.h"

@interface RechargeTypeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RechargeTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择充值方式";
    [self setupUI];
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
        CGFloat tableViewH = MScreenHeight - MStatusBarH - MNavBarH;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, tableViewH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"PayOrderTableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = MBlackTextColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = MGrayTextColor;
    }
    cell.imageView.backgroundColor = MPlaceholderColor;
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"微信";
    }else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"支付宝";
    }
    CGSize itemSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *parameters = @{
        @"payType": @(indexPath.row),
        @"money": @(self.money)
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/user/ext/charge" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"充值成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RechargeSuccess" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

@end
