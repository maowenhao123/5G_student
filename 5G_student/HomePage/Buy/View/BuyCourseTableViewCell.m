//
//  BuyCourseTableViewCell.m
//  5G_student
//
//  Created by dahe on 2020/3/9.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BuyCourseTableViewCell.h"

@interface BuyCourseTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *lecturerNameLabel;

@end

@implementation BuyCourseTableViewCell

#pragma mark - Setting
- (void)setCourseModel:(CourseModel *)courseModel
{
    _courseModel = courseModel;
    
    NSString *tag = @"";
    if (_courseModel.courseType == 1) {
        tag = @"视频课";
    }else if (_courseModel.courseType == 2)
    {
        tag = @"公开课";
    }else if (_courseModel.courseType == 3)
    {
        tag = @"一对一";
    }
    NSString *nameString = [NSString stringWithFormat:@" %@", _courseModel.courseName];
    self.nameLabel.attributedText = [Tool getAttributedTextWithTag:tag contentText:nameString];
    
    if (_courseModel.courseType == 1) {
        self.infoLabel.text = [NSString stringWithFormat:@"共%ld讲", _courseModel.periodList.count];
    }else if (_courseModel.courseType == 2)
    {
        self.infoLabel.text = [NSString stringWithFormat:@"共%ld讲", _courseModel.periodList.count];
    }else if (_courseModel.courseType == 3)
    {
        if (self.periodId > 0) {
            [self getPeriodDataWithCourseId:_courseModel.id];
        }
    }
    
    self.lecturerNameLabel.text = [NSString stringWithFormat:@"讲师：%@", _courseModel.lecturer.lecturerName];
}

#pragma mark - 请求数据
- (void)getPeriodDataWithCourseId:(NSInteger)courseId
{
    NSDictionary *parameters = @{
        @"courseId": @(courseId)
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/user/period/list" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.contentView];
        if (SUCCESS) {
            NSArray * dataArray = [PeriodModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            PeriodModel * selPeriodModel;
            for (PeriodModel * periodModel in dataArray) {
                if (self.periodId == periodModel.id) {
                    selPeriodModel = periodModel;
                    break;
                }
            }
            NSString *periodTime = [NSString stringWithFormat:@"%@~%@", selPeriodModel.startTime, selPeriodModel.endTime];
            self.infoLabel.text = periodTime;
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
    }];
}

@end
