//
//  CourseListViewController.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseListViewController : BaseViewController

@property (nonatomic, copy) NSString *categoryId1;
@property (nonatomic, copy) NSString *categoryId2;
@property (nonatomic, assign) NSInteger courseType;

@end

NS_ASSUME_NONNULL_END
