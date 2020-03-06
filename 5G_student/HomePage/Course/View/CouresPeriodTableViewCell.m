//
//  CouresPeriodTableViewCell.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/24.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CouresPeriodTableViewCell.h"

@interface CouresPeriodTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CouresPeriodTableViewCell

#pragma mark - Setting
- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    self.indexLabel.text = [NSString stringWithFormat:@"第%ld课", _index + 1];
}

- (void)setPeriodModel:(PeriodModel *)periodModel
{
    _periodModel = periodModel;
    
    self.nameLabel.text = _periodModel.periodName;
    self.timeLabel.text = _periodModel.periodName;
}

@end
