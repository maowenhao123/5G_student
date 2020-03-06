//
//  MHttpTool.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/11.
//  Copyright © 2020 jiuge. All rights reserved.
//

#define MBaseUrl @"http://39.96.170.92:8081"

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "MJRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHttpTool : NSObject

+ (MHttpTool *)shareInstance;

#pragma mark - POST请求
- (void)postWithParameters:(NSDictionary *)parameters url:(NSString *)url success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
#pragma mark - 图片上传
- (void)uploadWithImage:(UIImage *)image currentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount Success:(void (^)(id json))success Failure:(void (^)(NSError * error))failure;
#pragma mark - 视频上传
- (void)upFileWithVideo:(NSURL *)videoURL Success:(void (^)(id json))success Failure:(void (^)(NSError * error))failure;

@end

NS_ASSUME_NONNULL_END
