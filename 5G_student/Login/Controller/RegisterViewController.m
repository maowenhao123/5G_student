//
//  RegisterViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/11.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "RegisterViewController.h"
#import "MValidateTool.h"
#import "MUserDefaultTool.h"

@interface RegisterViewController ()
{
    int oneMinute;
}
@property (nonatomic, weak) UITextField *phoneTF;
@property (nonatomic, weak) UITextField *phoneCodeTF;
@property (nonatomic, weak) UIButton *phoneCodeBtn;
@property (nonatomic, weak) UITextField * passwordTF;
@property (nonatomic, weak) UIButton * registerBtn;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RegisterViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.phoneCodeBtn.enabled = YES;
    [self.phoneCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    self.title = @"注册";
    [self setupChilds];
}

#pragma mark - 布局子控件
- (void)setupChilds
{
    NSArray *placeholders = @[@"请输入新手机号码", @"请输入验证码", @"请输入密码,6-20位数字或字母组合"];
    CGFloat textFieldH = 52;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 9, MScreenWidth, textFieldH * placeholders.count)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    CGFloat phoneCodeBtnW = 86;
    CGFloat phoneCodeBtnH = 30;
    for (int i = 0; i < placeholders.count; i++) {
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(MMargin, textFieldH * i, MScreenWidth -  2 * MMargin, textFieldH)];
        if (i == 0) {
            self.phoneTF = textField;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (i == 1)
        {
            self.phoneCodeTF = textField;
            textField.frame = CGRectMake(MMargin, textFieldH * i, MScreenWidth -  2 * MMargin - phoneCodeBtnW - MMargin, textFieldH);
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (i == 2)
        {
            self.passwordTF = textField;
            textField.secureTextEntry = YES;
        }
        textField.font = [UIFont systemFontOfSize:16];
        textField.textColor = MBlackTextColor;
        textField.tintColor = MDefaultColor;
        textField.placeholder = placeholders[i];
        [backView addSubview:textField];
        
        //分割线
        if (i != 0) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, textFieldH * i, MScreenWidth, 1)];
            line.backgroundColor = MWhiteLineColor;
            [backView addSubview:line];
        }
    }
    
    //获取验证吗按钮
    UIButton * phoneCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneCodeBtn = phoneCodeBtn;
    phoneCodeBtn.frame = CGRectMake(MScreenWidth - phoneCodeBtnW - MMargin, textFieldH + (textFieldH - phoneCodeBtnH) / 2, phoneCodeBtnW, phoneCodeBtnH);
    [phoneCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [phoneCodeBtn setTitleColor:MDefaultColor forState:UIControlStateNormal];
    phoneCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [phoneCodeBtn addTarget:self action:@selector(getphoneCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    phoneCodeBtn.layer.masksToBounds = YES;
    phoneCodeBtn.layer.cornerRadius = phoneCodeBtn.height / 2;
    phoneCodeBtn.layer.borderColor = MDefaultColor.CGColor;
    phoneCodeBtn.layer.borderWidth = 1;
    [backView addSubview:phoneCodeBtn];
    
    //注册按钮
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerBtn = registerBtn;
    registerBtn.frame = CGRectMake(MMargin, CGRectGetMaxY(backView.frame) + 50, MScreenWidth - 2 * MMargin, 40);
    registerBtn.backgroundColor = MDefaultColor;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = registerBtn.height / 2;
    [registerBtn addTarget:self action:@selector(registerBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

- (void)getphoneCodeBtnPressed
{
    NSDictionary *parameters = @{
        @"mobile":self.phoneTF.text
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/api/user/send/code" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            [self.phoneCodeTF becomeFirstResponder];
            [self countDown];
        }else
        {
            ShowErrorView
            //倒计时失效
            self.phoneCodeBtn.enabled = YES;
            [self.phoneCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.timer invalidate];
            self.timer = nil;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"获取验证码失败"];
        //倒计时失效
        self.phoneCodeBtn.enabled = YES;
        [self.phoneCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }];
}

- (void)countDown
{
    if (!self.timer) {
        oneMinute = 60;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextSecond) userInfo:nil repeats:YES];
        self.timer = timer;
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)nextSecond
{
    self.phoneCodeBtn.enabled = NO;
    if(oneMinute > 0)
    {
        oneMinute--;
        [self.phoneCodeBtn setTitle:[NSString stringWithFormat:@"%d秒",oneMinute] forState:UIControlStateNormal];
    }else
    {
        self.phoneCodeBtn.enabled = YES;
        [self.phoneCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - 按钮点击
- (void)registerBtnDidClick:(UIButton *)button
{
    [self.view endEditing:YES];
    
    if (![MValidateTool validateMobile:self.phoneTF.text])//不是手机号码
    {
        [MBProgressHUD showError:@"您输入的手机号格式不对"];
        return;
    }
    if (MStringIsEmpty(self.phoneCodeTF.text))//没有输入验证码
    {
        [MBProgressHUD showError:@"您还未输入验证码"];
        return;
    }
    if (![MValidateTool validatePassword:self.passwordTF.text])//不是密码
    {
        [MBProgressHUD showError:@"您输入的密码格式不对"];
        return;
    }
    
    NSDictionary *parameters = @{
        @"mobile": self.phoneTF.text,
        @"password": self.passwordTF.text,
        @"code": self.phoneCodeTF.text
    };
    self.registerBtn.enabled = NO;
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/api/user/register" success:^(id json) {
        self.registerBtn.enabled = YES;
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"注册成功"];
            //存储信息
            [MUserDefaultTool saveObject:self.phoneTF.text forKey:@"login_name"];
            [MUserDefaultTool saveObject:json[@"data"][@"token"] forKey:@"token"];
            [MUserDefaultTool saveObject:json[@"data"][@"userno"] forKey:@"userno"];
            
            //登录成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
            
            //返回上上页面
            UIViewController *rootVC = self.presentingViewController;
            while (rootVC.presentingViewController) {
                rootVC = rootVC.presentingViewController;
            }
            [rootVC dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        self.registerBtn.enabled = YES;
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}



@end
