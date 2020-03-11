//
//  BuyCourseTableViewCell.h
//  5G_student
//
//  Created by dahe on 2020/3/9.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BuyCourseTableViewCell : UITableViewCell

@property (nonatomic, strong) CourseModel *courseModel;
@property (nonatomic, assign) NSInteger periodId;

@end

NS_ASSUME_NONNULL_END
