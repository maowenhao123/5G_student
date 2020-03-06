//
//  CourseTableViewCell.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/5.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseTableViewCell : UITableViewCell

@property (nonatomic, strong) CourseModel *courseModel;

@end

NS_ASSUME_NONNULL_END
