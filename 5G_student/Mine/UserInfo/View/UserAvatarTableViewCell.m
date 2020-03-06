//
//  UserAvatarTableViewCell.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "UserAvatarTableViewCell.h"

@implementation UserAvatarTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.width / 2;
}

@end
