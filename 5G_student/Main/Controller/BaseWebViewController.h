//
//  BaseWebViewController.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/23.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseWebViewController : BaseViewController

/*
 通过文件名请求数据
 */
- (instancetype)initWithFileName:(NSString *)fileName;
/*
 通过web请求数据
 */
- (instancetype)initWithWeb:(NSString *)web;
/*
 通过html请求数据
 */
- (instancetype)initWithHtmlStr:(NSString *)htmlStr;

@property (nonatomic, copy) NSString *web;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *htmlStr;

@end

NS_ASSUME_NONNULL_END
