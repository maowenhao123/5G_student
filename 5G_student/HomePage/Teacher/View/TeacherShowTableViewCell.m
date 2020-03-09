//
//  TeacherShowTableViewCell.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "TeacherShowTableViewCell.h"
#import "TeacherShowCollectionView.h"

@interface TeacherShowTableViewCell ()

@property (weak, nonatomic) IBOutlet TeacherShowCollectionView *teacherShowCollectionView;

@end

@implementation TeacherShowTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.teacherShowCollectionView.collectionView.scrollEnabled = NO;
}

- (void)setLecturerModel:(LecturerModel *)lecturerModel
{
    _lecturerModel = lecturerModel;
    
    self.teacherShowCollectionView.lecturerModel = _lecturerModel;
}

@end
