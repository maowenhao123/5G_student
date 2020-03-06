//
//  TeacherInfoTableViewCell.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeacherInfoTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *teacherId;
@property (nonatomic, strong) LecturerModel *lecturerModel;

@end

NS_ASSUME_NONNULL_END
