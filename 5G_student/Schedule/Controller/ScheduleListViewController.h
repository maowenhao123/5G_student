//
//  ScheduleListViewController.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleListViewController : BaseViewController

@property (nonatomic, assign) CourseType courseType;
@property (nonatomic, assign) NSInteger status;//1 未上课      4  已上课

@end

NS_ASSUME_NONNULL_END
