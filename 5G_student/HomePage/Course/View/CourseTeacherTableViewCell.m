//
//  CourseTeacherTableViewCell.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/24.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CourseTeacherTableViewCell.h"

@interface CourseTeacherTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CourseTeacherTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.width / 2;
}

#pragma mark - Setting
- (void)setLecturerModel:(LecturerModel *)lecturerModel
{
    _lecturerModel = lecturerModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_lecturerModel.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    self.nameLabel.text = _lecturerModel.lecturerName;
}


@end
