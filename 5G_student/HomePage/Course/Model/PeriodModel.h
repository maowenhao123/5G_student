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
@property (nonatomic, assign) NSInteger videoStatus;
@property (nonatomic, assign) NSInteger videoVid;

@end

@interface PeriodModel : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger auditStatus;
@property (nonatomic, copy) NSString *docName;
@property (nonatomic, copy) NSString *docUrl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL isDoc;
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, copy) NSString *periodDesc;
@property (nonatomic, copy) NSString *periodName;
@property (nonatomic, assign) NSInteger periodOriginal;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, strong) PeriodLiveModel *periodLive;
@property (nonatomic, strong) PeriodVideoModel *periodVideo;

@end

NS_ASSUME_NONNULL_END
