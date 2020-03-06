//
//  TeacherHeaderFooterView.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "TeacherHeaderFooterView.h"
#import "TeacherShowViewController.h"

@interface TeacherHeaderFooterView ()

@end

@implementation TeacherHeaderFooterView

+ (TeacherHeaderFooterView *)headerViewWithTableView:(UITableView *)talbeView
{
    static NSString *ID = @"TeacherHeaderFooterViewId";
    TeacherHeaderFooterView *headerView = [talbeView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if(headerView == nil)
    {
        headerView = [[TeacherHeaderFooterView alloc] initWithReuseIdentifier:ID];
    }
    return headerView;
}

//初始化子控件
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 9)];
    lineView.backgroundColor = MBackgroundColor;
    [self.contentView addSubview:lineView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(lineView.frame), MScreenWidth - 2 * MMargin - 100, 45)];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = MBlackTextColor;
    [self.contentView addSubview:titleLabel];
    
    UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreButton = moreButton;
    moreButton.frame = CGRectMake(MScreenWidth - MMargin - 100, CGRectGetMaxY(lineView.frame), 100, 45);
    [moreButton setTitle:@"更多>" forState:UIControlStateNormal];
    [moreButton setTitleColor:MGrayTextColor forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
    moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [moreButton addTarget:self action:@selector(moreButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreButton];
}

- (void)moreButtonDidClick
{
    [self.viewController.navigationController pushViewController:[TeacherShowViewController new] animated:YES];
}

@end
