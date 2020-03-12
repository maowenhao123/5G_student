//
//  LoginViewController.m
//  5G_student
//
//  Created by dahe on 2020/1/8.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MValidateTool.h"
#import "MUserDefaultTool.h"

@interface LoginViewController ()

@property (nonatomic, weak) UITextField * phoneTF;
@property (nonatomic, weak) UITextField * passwordTF;
@property (nonatomic, weak) UIButton * loginBtn;

@end

@implementation LoginViewController

#pragma mark - 视图的生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChilds];
}

#pragma mark - 布局子控件
- (void)setupChilds
{
    //close
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat closeButtonWH = 30;
    closeButton.frame = CGRectMake(MScreenWidth - closeButtonWH - MMargin, MStatusBarH + 10, closeButtonWH, closeButtonWH);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"login_close_icon"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    //login
    UIImageView * logoImageView = [[UIImageView alloc] init];
    CGFloat logoImageViewWH = 80;
    logoImageView.frame = CGRectMake((MScreenWidth - logoImageViewWH) / 2, MStatusBarH + 100, logoImageViewWH, logoImageViewWH);
    logoImageView.image = [UIImage imageNamed:@"login_icon"];
    [self.view addSubview:logoImageView];
    
    UIView * lastView;
    //输入框
    NSArray * placeholders = @[@"请输入手机号", @"请输入密码"];
    CGFloat textFieldH = 52;
    
    for (int i = 0; i < 2; i++) {
        UITextField * textField = [[UITextField alloc] init];
        textField.tintColor = MDefaultColor;
        textField.font = [UIFont systemFontOfSize:16];
        textField.textColor = MBlackTextColor;
        textField.placeholder = placeholders[i];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.borderStyle = UITextBorderStyleNone;
        CGFloat textFieldX = 60;
        CGFloat textFieldY = CGRectGetMaxY(logoImageView.frame) + 34;
        CGFloat textFieldW = MScreenWidth - 2 * textFieldX;
        if (i == 0) {//账号
            self.phoneTF = textField;
            textField.text = [MUserDefaultTool getObjectForKey:@"login_name"];
        }else//密码
        {
            self.passwordTF = textField;
            textFieldY = CGRectGetMaxY(lastView.frame);
            textField.secureTextEntry = YES;
            
            UIButton * showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat showPasswordButtonWH = 20;
            showPasswordButton.frame = CGRectMake(textFieldW - showPasswordButtonWH, (textFieldH - showPasswordButtonWH) / 2, showPasswordButtonWH, showPasswordButtonWH);
            [showPasswordButton setBackgroundImage:[UIImage imageNamed:@"login_password_invisible"] forState:UIControlStateNormal];
            [showPasswordButton setBackgroundImage:[UIImage imageNamed:@"login_password_visible"] forState:UIControlStateSelected];
            [showPasswordButton addTarget:self action:@selector(showPasswordButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [textField addSubview:showPasswordButton];
        }
        textField.frame = CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH);
        [self.view addSubview:textField];
        lastView = textField;
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(textField.frame) - 1, MScreenWidth - 2 * 40, 1)];
        line.backgroundColor = MWhiteLineColor;
        [self.view addSubview:line];
    }
    
    //登录按钮
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn = loginBtn;
    CGFloat buttonX = 40;
    CGFloat buttonY = CGRectGetMaxY(lastView.frame) + 30;
    CGFloat buttonW = MScreenWidth - 2 * buttonX;
    CGFloat buttonH = 39;
    loginBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    loginBtn.backgroundColor = MDefaultColor;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = buttonH / 2;
    [loginBtn addTarget:self action:@selector(loginBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    lastView = loginBtn;
    
    //忘记密码
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:@"忘记密码>" forState:UIControlStateNormal];
        if (i == 1) {
            [button setTitle:@"立即注册>" forState:UIControlStateNormal];
        }
        [button setTitleColor:MGrayTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        CGSize buttonSize = [button.currentTitle sizeWithLabelFont:button.titleLabel.font];
        CGFloat buttonW = buttonSize.width;
        CGFloat buttonH = buttonSize.height;
        CGFloat buttonX = MScreenWidth / 2 - buttonW - MMargin;
        if (i == 1) {
            buttonX = MScreenWidth / 2 + MMargin;
        }
        CGFloat buttonY = CGRectGetMaxY(lastView.frame) + 40;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

#pragma mark - 按钮点击
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPasswordButtonDidClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        self.passwordTF.secureTextEntry = NO;
    } else
    {
        self.passwordTF.secureTextEntry = YES;
    }
}

- (void)buttonDidClick:(UIButton *)button
{
    if (button.tag == 0) {//忘记密码?
        
    }else//新用户注册
    {
        RegisterViewController * registerVC = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
}

- (void)loginBtnDidClick:(UIButton *)button
{
    [self.view endEditing:YES];
    
    if (![MValidateTool validateMobile:self.phoneTF.text])//不是手机号码
    {
        [MBProgressHUD showError:@"您输入的手机号格式不对"];
        return;
    }
    if (![MValidateTool validatePassword:self.passwordTF.text])//不是密码
    {
        [MBProgressHUD showError:@"您输入的密码格式不对"];
        return;
    }
    
    NSDictionary *parameters = @{
        @"mobile": self.phoneTF.text,
        @"password": self.passwordTF.text
    };
    self.loginBtn.enabled = NO;
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/api/user/login/password" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        self.loginBtn.enabled = YES;
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"登录成功"];
            //存储信息
            [MUserDefaultTool saveObject:self.phoneTF.text forKey:@"login_name"];
            [MUserDefaultTool saveObject:json[@"data"][@"token"] forKey:@"token"];
            [MUserDefaultTool saveObject:json[@"data"][@"userno"] forKey:@"userno"];
            
            //登录成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
            
            //返回上上页面
            [self back];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        self.loginBtn.enabled = YES;
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


@end
