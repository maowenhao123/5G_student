//
//  CouresPeriodTableViewCell.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/24.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeriodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CouresPeriodTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) PeriodModel *periodModel;

@end

NS_ASSUME_NONNULL_END
