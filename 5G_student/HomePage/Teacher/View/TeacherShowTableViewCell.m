//
//  TeacherShowTableViewCell.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "TeacherShowTableViewCell.h"

@interface TeacherShowTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView2;

@end

@implementation TeacherShowTableViewCell

#pragma mark - Setting
- (void)setLecturerModel:(LecturerModel *)lecturerModel
{
    _lecturerModel = lecturerModel;
    
    
}

@end
