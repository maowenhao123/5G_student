//
//  BalanceDetailModel.h
//  5G_student
//
//  Created by dahe on 2020/3/12.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BalanceDetailModel : NSObject

@property (nonatomic, assign) NSInteger balance;
@property (nonatomic, copy) NSString * gmtCreate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString * lecturerUserNo;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
