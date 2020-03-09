//
//  VideoSchedulePeriodTableViewCell.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/24.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "VideoSchedulePeriodTableViewCell.h"

@interface VideoSchedulePeriodTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation VideoSchedulePeriodTableViewCell

#pragma mark - Setting
- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    
    if (_checked) {
        self.nameLabel.textColor = MDefaultColor;
    }else
    {
        self.nameLabel.textColor = MBlackTextColor;
    }
}

- (void)setPeriodModel:(PeriodModel *)periodModel
{
    _periodModel = periodModel;
    
    self.nameLabel.text = _periodModel.periodName;
}

@end

