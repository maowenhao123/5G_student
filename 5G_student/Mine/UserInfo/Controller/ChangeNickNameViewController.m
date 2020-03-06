//
//  ChangeNickNameViewController.m
//  5G_student
//
//  Created by dahe on 2020/3/6.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "ChangeNickNameViewController.h"

@interface ChangeNickNameViewController ()

@property (nonatomic, weak) UITextField * nickNameTF;

@end

@implementation ChangeNickNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改昵称";
    self.view.backgroundColor = MBackgroundColor;
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBarDidClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:MBarItemAttDic forState:UIControlStateNormal];
    
    UITextField *nickNameTF = [[UITextField alloc] initWithFrame:CGRectMake(MMargin, MMargin, MScreenWidth - 2 * MMargin, 40)];
    self.nickNameTF = nickNameTF;
    nickNameTF.placeholder = @"请输入昵称";
    nickNameTF.tintColor = MDefaultColor;
    nickNameTF.textColor = MBlackTextColor;
    nickNameTF.font = [UIFont systemFontOfSize:16];
    nickNameTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:nickNameTF];
    
    UILabel * promptLabel = [[UILabel alloc]init];
    promptLabel.numberOfLines = 0;
    NSString * promptStr = @"请输入10位以内的汉字、字母或组合";
    NSMutableAttributedString * promptAttStr = [[NSMutableAttributedString alloc]initWithString:promptStr];
    [promptAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, promptAttStr.length)];
    [promptAttStr addAttribute:NSForegroundColorAttributeName value:MGrayTextColor range:NSMakeRange(0, promptAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [promptAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, promptAttStr.length)];
    promptLabel.attributedText = promptAttStr;
    CGSize promptSize = [promptLabel.attributedText boundingRectWithSize:CGSizeMake(MScreenWidth - MMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    promptLabel.frame = CGRectMake(MMargin, CGRectGetMaxY(nickNameTF.frame) + 10, MScreenWidth - MMargin * 2, promptSize.height);
    [self.view addSubview:promptLabel];
}

- (void)saveBarDidClick
{
    [self.view endEditing:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(changeNickNameViewControllerDidConfirm:)]) {
        [_delegate changeNickNameViewControllerDidConfirm:self.nickNameTF.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
