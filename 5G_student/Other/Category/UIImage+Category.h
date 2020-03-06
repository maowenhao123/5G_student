//
//  UIImage+Category.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)

/**
 *  返回一张给定颜色和大小的图片
 */
+ (UIImage *)ImageFromColor:(UIColor *)color WithRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
