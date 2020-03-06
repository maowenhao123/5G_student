//
//  FilterCourseView.m
//  5G_student
//
//  Created by dahe on 2020/3/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "FilterCourseView.h"

@interface FilterCourseView ()<UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) UIView *contentView;
@property (strong, nonatomic) NSMutableArray *filterButtons;
@property (nonatomic, strong) UITextField *minTF;
@property (nonatomic, strong) UITextField *maxTF;

@end

@implementation FilterCourseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 布局子视图
- (void)setupUI
{
    self.backgroundColor = MColor(0, 0, 0, 0.0);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(self.width, 0, self.width * 0.8, self.height)];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, MStatusBarH, contentView.width - 2 * MMargin, MNavBarH)];
    titleLabel.text = @"筛选适合您的课程";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = MBlackTextColor;
    [contentView addSubview:titleLabel];
    
    CGFloat maxY = CGRectGetMaxY(titleLabel.frame);
    NSArray *filterArray = @[
        @[@"视频课", @"公开课"],
        @[@"上午", @"下午", @"晚上"],
        @[@"免费"],
    ];
    CGFloat filterButtonW = 72;
    CGFloat filterButtonH = 32;
    for (int i = 0; i < filterArray.count; i++) {
        UILabel * filterTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, maxY, contentView.width - 2 * MMargin, 30)];
        if (i == 0) {
            filterTypeLabel.text = @"上课方式";
        }else if (i == 1)
        {
            filterTypeLabel.text = @"上课时间";
        }else if (i == 2)
        {
            filterTypeLabel.text = @"课程价格";
        }
        filterTypeLabel.font = [UIFont systemFontOfSize:16];
        filterTypeLabel.textColor = MBlackTextColor;
        [contentView addSubview:filterTypeLabel];
        maxY = CGRectGetMaxY(filterTypeLabel.frame) + 5;
        
        NSArray *subFilterArray = filterArray[i];
        
        for (int j = 0; j < subFilterArray.count; j++) {
            UIButton * filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            filterButton.tag = i * 100 + j;
            filterButton.frame = CGRectMake(MMargin + (filterButtonW + MMargin) * j, maxY, filterButtonW, filterButtonH);
            [filterButton setTitle:subFilterArray[j] forState:UIControlStateNormal];
            [filterButton setTitleColor:MBlackTextColor forState:UIControlStateNormal];
            [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            filterButton.titleLabel.font = [UIFont systemFontOfSize:15];
            filterButton.layer.cornerRadius = filterButton.height / 2;
            filterButton.layer.masksToBounds = YES;
            if (j == 0) {
                filterButton.selected = YES;
                filterButton.backgroundColor = MDefaultColor;
                filterButton.layer.borderWidth = 0;
            }else
            {
                filterButton.selected = NO;
                filterButton.backgroundColor = [UIColor whiteColor];
                filterButton.layer.borderColor = MGrayLineColor.CGColor;
                filterButton.layer.borderWidth = 1;
            }
            [filterButton addTarget:self action:@selector(filterButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:filterButton];
            NSMutableArray *subFilterButtons = self.filterButtons[i];
            [subFilterButtons addObject:filterButton];
            if (j == subFilterArray.count - 1) {
                if (i == 0) {
                    maxY = CGRectGetMaxY(filterButton.frame) + 7;
                }else
                {
                    maxY = CGRectGetMaxY(filterButton.frame) + MMargin;
                }
            }
        }
        if (i == 0) {
            //温馨提示
            UILabel * promptLabel = [[UILabel alloc]init];
            promptLabel.numberOfLines = 0;
            NSString * promptStr = @"*视频课为点播课，购买后随时可学习\n*公开课为一对多直播课，老师现场教学";
            NSMutableAttributedString * promptAttStr = [[NSMutableAttributedString alloc]initWithString:promptStr];
            [promptAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, promptAttStr.length)];
            [promptAttStr addAttribute:NSForegroundColorAttributeName value:MGrayTextColor range:NSMakeRange(0, promptAttStr.length)];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:3];
            [promptAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, promptAttStr.length)];
            promptLabel.attributedText = promptAttStr;
            CGSize promptSize = [promptLabel.attributedText boundingRectWithSize:CGSizeMake(contentView.width - MMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            promptLabel.frame = CGRectMake(MMargin, maxY, contentView.width - MMargin * 2, promptSize.height + 5);
            [contentView addSubview:promptLabel];
            maxY = CGRectGetMaxY(promptLabel.frame) + MMargin;
        }else if (i == 2)
        {
            CGFloat textFieldH = filterButtonH;
            CGFloat textFieldW = filterButtonW;
            CGFloat yuanLabelW = 25;
            NSArray *placeholders = @[@"最低价", @"最高价"];
            for (int i = 0; i < 2; i++) {
                UITextField * textField = [[UITextField alloc] init];
                if (i == 0) {
                    self.minTF = textField;
                }else
                {
                    self.maxTF = textField;
                }
                textField.frame = CGRectMake(MMargin + (textFieldW + yuanLabelW + 30) * i, maxY, textFieldW, textFieldH);
                textField.tag = i;
                textField.backgroundColor = MBackgroundColor;
                textField.tintColor = MDefaultColor;
                textField.textColor = MBlackTextColor;
                textField.font = [UIFont systemFontOfSize:14];
                textField.placeholder = placeholders[i];
                textField.delegate = self;
                textField.textAlignment = NSTextAlignmentCenter;
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                textField.borderStyle = UITextBorderStyleNone;
                textField.layer.masksToBounds = YES;
                textField.layer.cornerRadius = textFieldH / 2;
                [contentView addSubview:textField];
                
                UILabel * yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame), maxY, yuanLabelW, textFieldH)];
                yuanLabel.text = @"元";
                yuanLabel.font = [UIFont systemFontOfSize:15];
                yuanLabel.textColor = MBlackTextColor;
                yuanLabel.textAlignment = NSTextAlignmentCenter;
                [contentView addSubview:yuanLabel];
                
                if (i == 0) {
                    UIView * line = [[UIView alloc] init];
                    line.frame = CGRectMake(CGRectGetMaxX(yuanLabel.frame) + 3, maxY + textFieldH / 2, 20, 1);
                    line.backgroundColor = MGrayLineColor;
                    [contentView addSubview:line];
                }
            }
            
        }
    }
    
    CGFloat confirmButtonY = self.height - 50;
    if (IsBangIPhone) {
        confirmButtonY = self.height - 40 - MSafeBottomMargin;
    }
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(MMargin, confirmButtonY, contentView.width - 2 * MMargin, 40);
    confirmButton.backgroundColor = MDefaultColor;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmButton.layer.cornerRadius = confirmButton.height / 2;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton addTarget:self action:@selector(confirmButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:confirmButton];
    
    //动画
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = MColor(0, 0, 0, 0.4);
        contentView.x = self.width - contentView.width;
    }];
}

#pragma mark - Getting
- (NSMutableArray *)filterButtons
{
    if (!_filterButtons) {
        _filterButtons = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            [_filterButtons addObject:[NSMutableArray array]];
        }
    }
    return _filterButtons;
}

- (void)filterButtonDidClick:(UIButton *)button
{
    NSMutableArray *subFilterButtons = self.filterButtons[button.tag / 100];
    for (UIButton * filterButton in subFilterButtons) {
        if (filterButton.selected && filterButton != button) {
            filterButton.selected = NO;
            filterButton.backgroundColor = [UIColor whiteColor];
            filterButton.layer.borderColor = MGrayLineColor.CGColor;
            filterButton.layer.borderWidth = 1;
        }else if (filterButton == button)
        {
            filterButton.selected = YES;
            filterButton.backgroundColor = MDefaultColor;
            filterButton.layer.borderWidth = 0;
        }
    }
    if ([button.currentTitle isEqualToString:@"免费"] && button.selected) {
        self.minTF.text = nil;
        self.maxTF.text = nil;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!MStringIsEmpty(textField.text)) {
        NSMutableArray *subFilterButtons = self.filterButtons[2];
        UIButton * filterButton = subFilterButtons.firstObject;
        filterButton.selected = NO;
        filterButton.backgroundColor = [UIColor whiteColor];
        filterButton.layer.borderColor = MGrayLineColor.CGColor;
        filterButton.layer.borderWidth = 1;
    }
}

- (void)confirmButtonDidClick
{
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.contentView.superview];
        if (CGRectContainsPoint(self.contentView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}

@end
