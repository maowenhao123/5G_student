//
//  UITableView+NoData.m
//  5G_teacher
//
//  Created by dahe on 2020/3/12.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "UITableView+NoData.h"

@implementation UITableView (NoData)

- (void)showNoDataWithRowCount:(NSInteger)rowCount
{
    [self showNoDataWithTitle:@"暂无数据" rowCount:rowCount];
}

- (void)showNoDataWithTitle:(NSString *)title rowCount:(NSInteger)rowCount
{
    UIView * backView = [[UIView alloc] initWithFrame:self.bounds];
    
    //图片
    UIImage * image = [UIImage imageNamed:@"no_data"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    [backView addSubview:imageView];
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = MGrayTextColor;
    [backView addSubview:titleLabel];

    CGFloat imageViewW = image.size.width;
    CGFloat imageViewH = image.size.height;
    CGSize titleLabelSize = [titleLabel.text sizeWithLabelFont:titleLabel.font];
    CGFloat titleLabelW = titleLabelSize.width;
    CGFloat titleLabelH = titleLabelSize.height;
    CGFloat imageViewY = (backView.height - (imageViewH + 5 + titleLabelH)) * 0.39;
    imageView.frame = CGRectMake((backView.width - imageViewW) / 2, imageViewY, imageViewW, imageViewH);
    titleLabel.frame = CGRectMake((backView.width - titleLabelW) / 2, CGRectGetMaxY(imageView.frame) + 5, titleLabelW, titleLabelH);

    if (rowCount == 0) {
        self.backgroundView = backView;
    }else
    {
        self.backgroundView = nil;
    }
}


@end
