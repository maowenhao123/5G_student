//
//  HobbyPickerView.h
//  5G_student
//
//  Created by dahe on 2020/3/5.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HobbyPickerViewBlock)(NSDictionary * categoryDic, NSDictionary * subjectDic);

@interface HobbyPickerView : UIView

@property (copy, nonatomic) HobbyPickerViewBlock block;

- (void)show;

@end

NS_ASSUME_NONNULL_END
