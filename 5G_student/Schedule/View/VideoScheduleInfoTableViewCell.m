//
//  VideoScheduleInfoTableViewCell.m
//  5G_student
//
//  Created by dahe on 2020/3/9.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "VideoScheduleInfoTableViewCell.h"

@interface VideoScheduleInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation VideoScheduleInfoTableViewCell

#pragma mark - Setting
- (void)setInfo:(NSString *)info
{
    _info = info;
    
    self.infoLabel.text = info;
}

@end
