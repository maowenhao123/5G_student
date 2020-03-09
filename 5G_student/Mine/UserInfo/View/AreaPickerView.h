//
//  AreaPickerView.h
//  5G_student
//
//  Created by dahe on 2020/3/9.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AreaPickerViewBlock)(NSString * areaStr, NSString * subAreaStr);

@interface AreaPickerView : UIView

@property (copy, nonatomic) AreaPickerViewBlock block;

- (void)show;

@end

NS_ASSUME_NONNULL_END
