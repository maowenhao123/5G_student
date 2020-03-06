//
//  LiveModel.h
//  5G_student
//
//  Created by 毛文豪 on 2020/3/3.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) NSInteger isRecord;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger onlineCount;
@property (nonatomic, copy) NSString *pullUrl;
@property (nonatomic, copy) NSString *pushUrl;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) UInt32 roomId;
@property (nonatomic, assign) UInt32 sdkAppId;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
