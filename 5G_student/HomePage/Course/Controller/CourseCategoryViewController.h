//
//  CourseCategoryViewController.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseCategoryViewController : BaseViewController

@property (nonatomic, copy) NSDictionary *categoryDic;
@property (nonatomic, assign) NSInteger courseType;

@end

NS_ASSUME_NONNULL_END
