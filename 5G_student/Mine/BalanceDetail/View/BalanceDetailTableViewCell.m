//
//  BalanceDetailTableViewCell.m
//  5G_student
//
//  Created by dahe on 2020/3/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BalanceDetailTableViewCell.h"

@interface BalanceDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation BalanceDetailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabel.text = @"购买课程：钢琴指法练习";
    self.timeLabel.text = @"1月2日 12:01";
    self.moneyLabel.text = @"- ¥100";
    self.moneyLabel.textColor = MDefaultColor;
}


@end
