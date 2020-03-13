//
//  UITableView+NoData.h
//  5G_teacher
//
//  Created by dahe on 2020/3/12.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (NoData)

- (void)showNoDataWithRowCount:(NSInteger)rowCount;
- (void)showNoDataWithTitle:(NSString *)title rowCount:(NSInteger)rowCount;

@end

NS_ASSUME_NONNULL_END
