//
//  CourseInfoTableViewCell.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/24.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CourseInfoTableViewCell.h"

@interface CourseInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation CourseInfoTableViewCell

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
    
    self.infoLabel.text = [NSString stringWithFormat:@"共%ld讲：", _courseModel.periodList.count];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _courseModel.courseOriginal];
}

@end
