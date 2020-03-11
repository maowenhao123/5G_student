//
//  CourseTableViewCell.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/5.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CourseTableViewCell.h"

@interface CourseTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lecturerNameLabel;

@end

@implementation CourseTableViewCell

#pragma mark - Setting
- (void)setCourseModel:(CourseModel *)courseModel
{
    _courseModel = courseModel;
    
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:_courseModel.courseLogo] placeholderImage:[UIImage imageNamed:@""]];
    
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
    
    self.lecturerNameLabel.text = [NSString stringWithFormat:@"讲师：%@", _courseModel.lecturer.lecturerName];
    
    if (_courseModel.courseType == 1 || _courseModel.courseType == 3) {
        self.statusLabel.text = @"";
    }else if (_courseModel.courseType == 2)
    {
        self.statusLabel.text = [NSString stringWithFormat:@"%@", _courseModel.classTime];
    }
}


@end
