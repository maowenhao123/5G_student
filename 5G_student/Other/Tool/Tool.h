//
//  Tool.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/19.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject

/**
获取视频第一帧
*/
+ (UIImage *)getVideoPreViewImage:(NSURL *)path;
/**
获取带标签的富文本
*/
+ (NSAttributedString *)getAttributedTextWithTag:(NSString *)tag contentText:(NSString *)contentText;
/**
view转成image
*/
+ (UIImage *)imageWithUIView:(UIView *)view;
/**
 登录环信账号
 */
+ (void)loginImAccount;

@end

NS_ASSUME_NONNULL_END
