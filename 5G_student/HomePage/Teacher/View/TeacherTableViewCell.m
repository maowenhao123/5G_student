//
//  TeacherTableViewCell.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/23.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "TeacherTableViewCell.h"

@implementation TeacherTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.width / 2;
}

#pragma mark - Setting
- (void)setTeacherModel:(TeacherModel *)teacherModel
{
    _teacherModel = teacherModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_teacherModel.lecturer.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    if (!MStringIsEmpty(_teacherModel.lecturer.lecturerName)) {
        self.nameLabel.text = _teacherModel.lecturer.lecturerName;
    }else
    {
        self.nameLabel.text = _teacherModel.lecturer.lecturerMobile;
    }
    self.schoolLabel.text = [NSString stringWithFormat:@"毕业于%@ %ld年教龄", _teacherModel.lecturer.lecturerEmail, _teacherModel.lecturer.status];
}

@end
