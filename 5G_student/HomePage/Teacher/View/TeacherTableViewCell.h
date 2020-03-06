//
//  TeacherTableViewCell.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/23.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeacherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;

@property (nonatomic, strong) TeacherModel *teacherModel;

@end

NS_ASSUME_NONNULL_END
