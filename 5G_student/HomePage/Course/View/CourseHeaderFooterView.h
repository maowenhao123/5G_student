//
//  CourseHeaderFooterView.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/24.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseHeaderFooterView : UITableViewHeaderFooterView

+ (CourseHeaderFooterView *)headerViewWithTableView:(UITableView *)talbeView;

@property (nonatomic, weak) UILabel * titleLabel;

@end

NS_ASSUME_NONNULL_END
