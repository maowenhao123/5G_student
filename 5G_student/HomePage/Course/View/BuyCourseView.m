//
//  BuyCourseView.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/27.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BuyCourseView.h"
#import "PlaceOrderViewController.h"

@interface BuyCourseView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *priceLabel;

@end

@implementation BuyCourseView

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
    self.backgroundColor = MColor(0, 0, 0, 0.4);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 400 + MSafeBottomMargin)];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, 0, 100, 50)];
    titleLabel.text = @"已选课程";
    titleLabel.textColor = MBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:titleLabel];

    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(MScreenWidth - MMargin - 100, 0, 100, 50);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:MGrayTextColor forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) - 1, self.width, 1)];
    line.backgroundColor = MWhiteLineColor;
    [contentView addSubview:line];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(line.frame) + 10, MScreenWidth - 2 * MMargin, 40)];
    self.nameLabel = nameLabel;
    nameLabel.numberOfLines = 0;
    [contentView addSubview:nameLabel];
    
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(nameLabel.frame) + 5, MScreenWidth - 2 * MMargin, 20)];
    self.priceLabel = priceLabel;
    priceLabel.font = [UIFont systemFontOfSize:17];
    priceLabel.textColor = [UIColor redColor];
    [contentView addSubview:priceLabel];
    
    UIButton * applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IsBangIPhone) {
        applyButton.frame = CGRectMake(MMargin, contentView.height - 40 - MSafeBottomMargin, MScreenWidth - 2 * MMargin, 40);
    }else
    {
        applyButton.frame = CGRectMake(MMargin, contentView.height - 40 - 10, MScreenWidth - 2 * MMargin, 40);
    }
    applyButton.backgroundColor = MDefaultColor;
    [applyButton setTitle:@"立即报名" forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    applyButton.layer.cornerRadius = applyButton.height / 2;
    applyButton.layer.masksToBounds = YES;
    [applyButton addTarget:self action:@selector(applyButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:applyButton];
    
    //动画
    [UIView animateWithDuration:0.2 animations:^{
        contentView.y = self.height - contentView.height;
    }];
}

- (void)applyButtonDidClick
{
    PlaceOrderViewController * placeOrderVC = [[PlaceOrderViewController alloc] init];
    placeOrderVC.courseId = self.courseModel.id;
    [self.viewController.navigationController pushViewController:placeOrderVC animated:YES];
}

#pragma mark - Setting
- (void)setCourseModel:(CourseModel *)courseModel
{
    _courseModel = courseModel;
    
    NSString *tag = @"";
    if (_courseModel.courseType == 1) {
        tag = @"视频课";
    }else if (_courseModel.courseType == 2)
    {
        tag = @"公开课";
    }else if (_courseModel.courseType == 3)
    {
        tag = @"一对一";
    }
    NSString *nameString = [NSString stringWithFormat:@" %@", _courseModel.courseName];
    self.nameLabel.attributedText = [Tool getAttributedTextWithTag:tag contentText:nameString];
    CGSize nameLabelSize = [self.nameLabel.attributedText boundingRectWithSize:CGSizeMake(MScreenWidth - 2 * MMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.nameLabel.height = nameLabelSize.height + 10;
    
    self.priceLabel.y = CGRectGetMaxY(self.nameLabel.frame) + 5;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _courseModel.courseOriginal];
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
