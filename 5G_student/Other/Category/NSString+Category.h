//
//  NSString+Category.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/11.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Category)

/**
 * md5加密
 */
- (NSString *)md5HexDigest;

/**
 *
 *  @param font    字体大小
 *
 *  @return 返回文字所占用的label宽高
 */
- (CGSize)sizeWithLabelFont:(UIFont *)font;
/**
 *
 *  @param font    字体大小
 *  @param maxSize 文字受限区域
 *
 *  @return 返回文字所占用的label宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end

NS_ASSUME_NONNULL_END
