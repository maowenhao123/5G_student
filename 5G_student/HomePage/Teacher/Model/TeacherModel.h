//
//  TeacherModel.h
//  5G_student
//
//  Created by 毛文豪 on 2020/2/23.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LecturerModel : NSObject

@property (nonatomic, copy) NSString * gmtCreate;
@property (nonatomic, copy) NSString * gmtModified;
@property (nonatomic, copy) NSString * headImgUrl;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * introduce;
@property (nonatomic, copy) NSString * lecturerEmail;
@property (nonatomic, copy) NSString * lecturerMobile;
@property (nonatomic, copy) NSString * lecturerName;
@property (nonatomic, copy) NSString * lecturerProportion;
@property (nonatomic, copy) NSString * position;
@property (nonatomic, copy) NSString * sort;
@property (nonatomic, assign) NSInteger status;

@end

@interface TeacherModel : NSObject

@property (nonatomic, strong) LecturerModel *lecturer;

@end

NS_ASSUME_NONNULL_END
