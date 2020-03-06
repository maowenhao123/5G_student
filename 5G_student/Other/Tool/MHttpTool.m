//
//  MHttpTool.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/11.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "MHttpTool.h"
#import "AFNetworking.h"

@implementation MHttpTool

+ (MHttpTool *)shareInstance
{
    static MHttpTool *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[[self class] alloc] init];
    });
    return shareInstance;
}

//请求数据
- (void)postWithParameters:(NSDictionary *)parameters url:(NSString *)url success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters_mu = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parameters_mu setValue:@"lkbe88c235cd93421ca02756138b932875" forKey:@"clientId"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    if (Token) {
        [manager.requestSerializer setValue:Token forHTTPHeaderField:@"token"];
    }
    [manager POST:[NSString stringWithFormat:@"%@%@", MBaseUrl, url] parameters:parameters_mu progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MLog(@"%@", responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MLog(@"%@", error);
        failure(error);
    }];
}

//图片上传
- (void)uploadWithImage:(UIImage *)image currentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount Success:(void (^)(id json))success Failure:(void (^)(NSError * error))failure
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;//圆环作为进度条
    if (currentIndex == -1) {
        HUD.label.text = @"图片上传中....";
    }else
    {
        HUD.label.text = [NSString stringWithFormat:@"%ld/%ld图片上传中....", currentIndex, totalCount];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@/user/api/upload/pic", MBaseUrl] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * data = UIImageJPEGRepresentation(image, 1.0);
        CGFloat dataKBytes = data.length/1000.0;
        CGFloat maxQuality = 0.9f;
        CGFloat lastData = dataKBytes;
        while (dataKBytes > 300 && maxQuality > 0.01f) {
            maxQuality = maxQuality - 0.01f;
            data = UIImageJPEGRepresentation(image, maxQuality);
            dataKBytes = data.length / 1000.0;
            if (lastData == dataKBytes) {
                break;
            }else{
                lastData = dataKBytes;
            }
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float progress = uploadProgress.fractionCompleted;
            HUD.progress = progress;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MLog(@"%@", responseObject);
        success(responseObject);
        [HUD hideAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MLog(@"%@", error);
        failure(error);
        [HUD hideAnimated:YES];
    }];
}

//视频上传
- (void)upFileWithVideo:(NSURL *)videoURL Success:(void (^)(id json))success Failure:(void (^)(NSError * error))failure
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;//圆环作为进度条
    HUD.label.text = @"视频上传中....";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/user/api/upload/video", MBaseUrl] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4",[formatter stringFromDate:[NSDate date]]];
        NSData *data = [[NSData alloc]initWithContentsOfURL:videoURL];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@".mp4"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD.progress = uploadProgress.fractionCompleted;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MLog(@"%@", responseObject);
        success (responseObject);
        [HUD hideAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MLog(@"%@", error);
        failure (error);
        [HUD hideAnimated:YES];
    }];
}

@end
