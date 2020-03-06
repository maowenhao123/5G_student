//
//  TeacherHeaderFooterView.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeacherHeaderFooterView : UITableViewHeaderFooterView

+ (TeacherHeaderFooterView *)headerViewWithTableView:(UITableView *)talbeView;

@property (nonatomic, weak) UILabel * titleLabel;
@property (nonatomic, weak) UIButton * moreButton;

@end

NS_ASSUME_NONNULL_END
