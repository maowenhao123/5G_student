//
//  CouresPeriodTableViewCell.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/24.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoSchedulePeriodTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, strong) PeriodModel *periodModel;

@end

NS_ASSUME_NONNULL_END
