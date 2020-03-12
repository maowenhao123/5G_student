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

- (void)setBalanceDetailModel:(BalanceDetailModel *)balanceDetailModel
{
    _balanceDetailModel = balanceDetailModel;
    
    self.titleLabel.text = _balanceDetailModel.remark;
    self.timeLabel.text = _balanceDetailModel.gmtCreate;
    if (_balanceDetailModel.money < 0) {
        self.moneyLabel.text = [NSString stringWithFormat:@"-¥%ld", -_balanceDetailModel.money];
        self.moneyLabel.textColor = MDefaultColor;
    }else
    {
        self.moneyLabel.text = [NSString stringWithFormat:@"+¥%ld", _balanceDetailModel.money];
        self.moneyLabel.textColor = MDefaultColor;
    }
}

@end
