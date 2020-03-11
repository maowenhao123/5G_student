//
//  ScheduleModel.h
//  5G_student
//
//  Created by dahe on 2020/3/11.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleModel : NSObject

@property (nonatomic, copy) NSString * classTime;
@property (nonatomic, strong) CourseModel *course;
@property (nonatomic, strong) LecturerModel *lecturer;
@property (nonatomic, copy) NSString * courseId;
@property (nonatomic, assign) NSInteger courseType;
@property (nonatomic, assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
