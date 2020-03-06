//
//  HomeHeaderFooterView.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "HomeHeaderFooterView.h"

@interface HomeHeaderFooterView ()

@end

@implementation HomeHeaderFooterView

+ (HomeHeaderFooterView *)headerViewWithTableView:(UITableView *)talbeView
{
    static NSString *ID = @"HomeHeaderFooterViewId";
    HomeHeaderFooterView *headerView = [talbeView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if(headerView == nil)
    {
        headerView = [[HomeHeaderFooterView alloc] initWithReuseIdentifier:ID];
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
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(lineView.frame), MScreenWidth - 2 * MMargin, 45)];
    self.titleLabel = titleLabel;
    titleLabel.text = @"最新发布";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = MBlackTextColor;
    [self.contentView addSubview:titleLabel];
}

@end
