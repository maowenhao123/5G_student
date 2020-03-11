//
//  PeriodModel.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/14.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PeriodLiveModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@end

@interface PeriodVideoModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *videoLength;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString * videoNo;
@property (nonatomic, copy) NSString * videoUrl;
@property (nonatomic, assign) NSInteger videoStatus;
@property (nonatomic, assign) NSInteger videoVid;
@property (nonatomic, copy) NSString * reserveUserId;

@end

@interface PeriodModel : NSObject

@property (nonatomic, copy) NSString *course;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL isRecord;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger onlineCount;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *pullUrl;
@property (nonatomic, copy) NSString *pushUrl;
@property (nonatomic, copy) NSString *sdkAppId;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *periodName;
@property (nonatomic, assign) NSInteger reserveUserId;
@property (nonatomic, strong) PeriodLiveModel *periodLive;
@property (nonatomic, strong) PeriodVideoModel *periodVideo;

@end

NS_ASSUME_NONNULL_END
