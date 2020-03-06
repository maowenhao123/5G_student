//
//  TextViewViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "TextViewViewController.h"
#import "IQTextView.h"

@interface TextViewViewController ()

@property (nonatomic, weak) IQTextView * textView;

@end

@implementation TextViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    IQTextView * textView = [[IQTextView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 200)];
    self.textView = textView;
    textView.backgroundColor = [UIColor whiteColor];
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.textColor = MBlackTextColor;
    textView.font = [UIFont systemFontOfSize:16];
    textView.tintColor = MDefaultColor;
    textView.text = self.text;
    textView.placeholder = @"请输入";
    [self.view addSubview:textView];
    
    //确定
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(15, CGRectGetMaxY(self.textView.frame) + 40, MScreenWidth - 2 * 15, 40);
    confirmButton.backgroundColor = MDefaultColor;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmButton.layer.cornerRadius = confirmButton.height / 2;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton addTarget:self action:@selector(confirmButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}

- (void)confirmButtonDidClick
{
    [self.view endEditing:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textViewViewControllerDidConfirm:)]) {
        [_delegate textViewViewControllerDidConfirm:self.textView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
