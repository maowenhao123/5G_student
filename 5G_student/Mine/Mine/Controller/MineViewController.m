//
//  MineViewController.m
//  5G_student
//
//  Created by dahe on 2020/1/8.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "MineViewController.h"
#import "UserInfoViewController.h"
#import "RechargeViewController.h"
#import "MessageViewController.h"
#import "MyAttentionViewController.h"
#import "BalanceDetailViewController.h"
#import "PointsDetailViewController.h"
#import "UserModel.h"

@interface MineViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView * avatarImageView;
@property (nonatomic, weak) UILabel * nickNameLabel;
@property (nonatomic, weak) UIButton * balanceButton;
@property (nonatomic, weak) UIButton * pointsButton;
@property (nonatomic, strong) UserModel *userModel;

@end

@implementation MineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    [self setupUI];
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self getUserData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserData) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserData) name:@"UpdateUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserData) name:@"RechargeSuccess" object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 请求数据
- (void)getUserData
{
    NSDictionary *parameters = @{
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/user/ext/view" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.scrollView.mj_header endRefreshing];
        if (SUCCESS) {
            self.userModel = [UserModel mj_objectWithKeyValues:json[@"data"]];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
        [self.scrollView.mj_header endRefreshing];
    }];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - MTabBarH)];
    self.scrollView = scrollView;
    scrollView.backgroundColor = MBackgroundColor;
    __weak typeof(self) wself = self;
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself getUserData];
    }];
    [self.view addSubview:scrollView];
    
    //顶部个人信息
    UIView * topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MStatusBarH + 170)];
    topBgView.backgroundColor = MDefaultColor;
    [topBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoDidTap)]];
    [scrollView addSubview:topBgView];
    
    //头像
    CGFloat avatarImageViewWH = 60;
    UIImageView * avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MMargin, MStatusBarH + 20, avatarImageViewWH, avatarImageViewWH)];
    self.avatarImageView = avatarImageView;
    avatarImageView.image = [UIImage imageNamed:@"avatar_placeholder"];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2;
    [topBgView addSubview:avatarImageView];
    
    //昵称
    CGFloat nickNameLabelX = CGRectGetMaxX(avatarImageView.frame) + 7;
    CGFloat nickNameLabelW = MScreenWidth - nickNameLabelX - 10;
    UILabel * nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickNameLabelX, avatarImageView.y, nickNameLabelW, avatarImageViewWH)];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.font = [UIFont boldSystemFontOfSize:16];
    nickNameLabel.textColor = [UIColor whiteColor];
    [topBgView addSubview:nickNameLabel];
    
    //余额
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        button.frame = CGRectMake(MScreenWidth / 9 + (MScreenWidth / 3 + MScreenWidth / 9) * i, CGRectGetMaxY(avatarImageView.frame) + 20, MScreenWidth / 3, 50);
        button.titleLabel.numberOfLines = 2;
        if (i == 0) {
            self.balanceButton = button;
            [button setAttributedTitle:[self getAttributedStringWithBigText:@"0" smallText:@"金额（元）"] forState:UIControlStateNormal];
        }else
        {
            self.pointsButton = button;
            [button setAttributedTitle:[self getAttributedStringWithBigText:@"0" smallText:@"积分"] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(funsButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBgView addSubview:button];
    }
    
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topBgView.frame), MScreenWidth, 0)];
    contentView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:contentView];
    
    //邀请
    UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteButton.frame = CGRectMake(MMargin, 20, MScreenWidth - 2 * MMargin, 45);
    inviteButton.backgroundColor = MViceColor;
    [inviteButton setTitle:@"邀请好友赚学费" forState:UIControlStateNormal];
    [inviteButton setTitleColor:MBlackTextColor forState:UIControlStateNormal];
    inviteButton.titleLabel.font = [UIFont systemFontOfSize:16];
    inviteButton.layer.masksToBounds = YES;
    inviteButton.layer.cornerRadius = inviteButton.height / 2;
    [inviteButton addTarget:self action:@selector(inviteButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:inviteButton];
    
    //功能
    NSArray * functionNames = @[
        @[@"优惠券", @"余额充值", @"积分商城"],
        @[@"我的消息", @"我的关注", @"客服", @"设置"]
    ];
    CGFloat maxY = CGRectGetMaxY(inviteButton.frame);
    CGFloat functionViewW = (MScreenWidth - 5 * MMargin) / 4;
    CGFloat functionImageViewWH = 35;
    for (int i = 0; i < functionNames.count; i++) {
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, maxY + 10, MScreenWidth - 2 * MMargin, 40)];
        if (i == 0) {
            titleLabel.text = @"我的账户";
        }else if (i == 1)
        {
            titleLabel.text = @"我的工具";
        }
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = MBlackTextColor;
        [contentView addSubview:titleLabel];
        maxY = CGRectGetMaxY(titleLabel.frame);
        
        NSArray * subFunctionNames = functionNames[i];
        for (int j = 0; j < subFunctionNames.count; j++) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(MMargin + (MMargin + functionViewW) * j, maxY, functionViewW, 70)];
            view.tag = 100 * i + j;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionViewDidTap:)];
            [view addGestureRecognizer:tap];
            [contentView addSubview:view];
            if (j == subFunctionNames.count - 1) {
                maxY = CGRectGetMaxY(view.frame);
            }
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((functionViewW - functionImageViewWH) / 2, 0, functionImageViewWH, functionImageViewWH)];
            imageView.image = [UIImage imageNamed:@"tabber_groupon_selected"];
            [view addSubview:imageView];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), functionViewW, 30)];
            label.text = subFunctionNames[j];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = MBlackTextColor;
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
        }
    }
    contentView.height = maxY + 10;
    scrollView.contentSize = CGSizeMake(MScreenWidth, CGRectGetMaxX(contentView.frame));
}

#pragma mark - Setting
- (void)setUserModel:(UserModel *)userModel
{
    _userModel = userModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    if (!MStringIsEmpty(_userModel.nickname)) {
        self.nickNameLabel.text = _userModel.nickname;
    }else
    {
        self.nickNameLabel.text = _userModel.mobile;
    }
    [self.balanceButton setAttributedTitle:[self getAttributedStringWithBigText:[NSString stringWithFormat:@"%ld", _userModel.account.balance] smallText:@"金额（元）"] forState:UIControlStateNormal];
    [self.pointsButton setAttributedTitle:[self getAttributedStringWithBigText:[NSString stringWithFormat:@"%ld", _userModel.points] smallText:@"积分"] forState:UIControlStateNormal];
}

#pragma mark - 点击事件
- (void)userInfoDidTap
{
    [self.navigationController pushViewController:[UserInfoViewController new] animated:YES];
}

- (void)inviteButtonDidClick
{
    
}

- (void)funsButtonDidClick:(UIButton *)button
{
    if (button.tag == 100) {
         [self.navigationController pushViewController:[BalanceDetailViewController new] animated:YES];
    }else if (button.tag == 101)
    {
        [self.navigationController pushViewController:[PointsDetailViewController new] animated:YES];
    }
}

- (void)functionViewDidTap:(UIGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;
    if (tag < 100) {//我的账户
        if (tag == 0) {
            
        }else if (tag == 1)
        {
            [self.navigationController pushViewController:[RechargeViewController new] animated:YES];
        }
    }else if (tag >= 100)//我的工具
    {
        if (tag == 100) {
            [self.navigationController pushViewController:[MessageViewController new] animated:YES];
        }else if (tag == 101)
        {
            [self.navigationController pushViewController:[MyAttentionViewController new] animated:YES];
        }
    }
}

#pragma mark - 获取富文本
- (NSAttributedString *)getAttributedStringWithBigText:(NSString *)bigText smallText:(NSString *)smallText
{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", bigText, smallText]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:[attStr.string rangeOfString:bigText]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[attStr.string rangeOfString:smallText]];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 3;
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    return attStr;
}

@end
