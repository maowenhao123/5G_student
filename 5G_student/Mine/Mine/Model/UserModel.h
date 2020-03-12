//
//  UserModel.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountModel : NSObject

@property (nonatomic, assign) NSInteger balance;
@property (nonatomic, assign) NSInteger enableBalance;
@property (nonatomic, assign) NSInteger freezeBalance;
@property (nonatomic, assign) NSInteger totalIncome;

@end

@interface UserModel : NSObject

@property (nonatomic, copy) NSString * auditOpinion;
@property (nonatomic, assign) NSInteger auditStatus;//0 审核中  1 审核通过  2 驳回
@property (nonatomic, copy) NSString * gmtCreate;
@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * headImgUrl;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * area;
@property (nonatomic, copy) NSString * hobby;
@property (nonatomic, assign) NSInteger statusId;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, strong) AccountModel * account;

@end

NS_ASSUME_NONNULL_END
