//
//  MValidateTool.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/11.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MValidateTool : NSObject

//银行卡号码
+ (BOOL) validateCardNumber:(NSString *)cardNumber;

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;


//密码
+ (BOOL) validatePassword:(NSString *)passWord;

//支付密码
+ (BOOL) validateFunPassword:(NSString *)passWord;

//昵称
+ (BOOL) validateNickname:(NSString *)nickname;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

@end

NS_ASSUME_NONNULL_END
