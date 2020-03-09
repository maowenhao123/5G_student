//
//  BottomPickerView.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ChoicePickerViewBlock)(NSInteger selectedIndex);

@interface BottomPickerView : UIView
/**
 *  创建一个底部的pickerView
 *
 *  @param dataArray  数据源
 *  @param index      当前选中的index
 */
- (instancetype)initWithArray:(NSArray *)dataArray index:(NSInteger)index;

@property (copy, nonatomic)ChoicePickerViewBlock block;

- (void)show;

@end

NS_ASSUME_NONNULL_END
